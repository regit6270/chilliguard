import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/batch/batch_bloc.dart';
import '../../widgets/batch/batch_card.dart';
import '../../widgets/batch/batch_filter_chips.dart';
import '../../widgets/common/bottom_navigation_bar.dart';
import '../../widgets/common/loading_overlay.dart';

class BatchListScreen extends StatefulWidget {
  const BatchListScreen({super.key});

  @override
  State<BatchListScreen> createState() => _BatchListScreenState();
}

class _BatchListScreenState extends State<BatchListScreen> {
  String _selectedFilter = 'active';

  @override
  void initState() {
    super.initState();
    _loadBatches();
  }

  void _loadBatches() {
    context.read<BatchBloc>().add(
          LoadBatches(
              status: _selectedFilter == 'all' ? null : _selectedFilter),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Crops'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Create New Batch',
            onPressed: () => context.push('/crop-management/new'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          Padding(
            padding: const EdgeInsets.all(16),
            child: BatchFilterChips(
              selectedFilter: _selectedFilter,
              onFilterChanged: (filter) {
                setState(() {
                  _selectedFilter = filter;
                });
                _loadBatches();
              },
            ),
          ),

          // Batch List
          Expanded(
            child: BlocBuilder<BatchBloc, BatchState>(
              builder: (context, state) {
                if (state is BatchLoading) {
                  return const LoadingOverlay(message: 'Loading batches...');
                }

                if (state is BatchError) {
                  return _buildErrorView(state.message);
                }

                if (state is BatchesLoaded) {
                  if (state.batches.isEmpty) {
                    return _buildEmptyView();
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      _loadBatches();
                      await Future.delayed(const Duration(milliseconds: 500));
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.batches.length,
                      itemBuilder: (context, index) {
                        final batch = state.batches[index];
                        return BatchCard(
                          batch: batch,
                          onTap: () => context.push(
                            '/crop-management/batch/${batch.batchId}',
                          ),
                        );
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          const ChilliGuardBottomNavigationBar(currentIndex: 3),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/crop-management/new'),
        icon: const Icon(Icons.add),
        label: const Text('New Batch'),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.agriculture_outlined, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 24),
            Text(
              'No Crop Batches',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Start tracking your chilli cultivation by creating a new batch',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.push('/crop-management/new'),
              icon: const Icon(Icons.add),
              label: const Text('Create Your First Batch'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          const Text(
            'Error Loading Batches',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadBatches,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
