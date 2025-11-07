import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart'; // ignore: unused_import
import '../../blocs/dashboard/dashboard_bloc.dart';
import '../../widgets/common/bottom_navigation_bar.dart';
import '../../widgets/common/loading_overlay.dart';
import '../../widgets/dashboard/active_batch_card.dart';
import '../../widgets/dashboard/alert_list_item.dart';
import '../../widgets/dashboard/feasibility_card.dart';
import '../../widgets/dashboard/sensor_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  void _loadDashboard() {
    // TODO: Get selected field ID from LocalStorageService
    const fieldId = 'field_123';
    context.read<DashboardBloc>().add(const LoadDashboardData(fieldId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const LoadingOverlay(message: 'Loading dashboard...');
            }

            if (state is DashboardError) {
              return _buildErrorView(state.message);
            }

            if (state is DashboardLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<DashboardBloc>().add(
                        const RefreshDashboardData('field_123'),
                      );
                  await Future.delayed(const Duration(milliseconds: 500));
                },
                child: CustomScrollView(
                  slivers: [
                    _buildAppBar(context, state),
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          // Critical Alerts Section (NEW - More prominent)
                          if (state.recentAlerts.isNotEmpty)
                            _buildAlertsSection(state),

                          const SizedBox(height: 16),

                          // Feasibility Score Card
                          _buildSectionHeader(context, 'Crop Readiness'),
                          const SizedBox(height: 12),
                          FeasibilityCard(
                            score: state.feasibilityScore,
                            status: state.feasibilityStatus,
                            onTap: () => context.push('/soil-health'),
                          ),

                          const SizedBox(height: 24),

                          // Soil Health Snapshot
                          _buildSectionHeader(context, 'Soil Health Snapshot'),
                          const SizedBox(height: 12),
                          if (state.latestSensorData != null)
                            _buildSensorGrid(state.latestSensorData!),

                          // Last Updated Timestamp
                          if (state.latestSensorData != null) ...[
                            const SizedBox(height: 8),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                'Last updated: ${_formatTimestamp(state.latestSensorData!.timestamp)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                              ),
                            ),
                          ],

                          const SizedBox(height: 24),

                          // Active Batch Card
                          _buildSectionHeader(context, 'Active Crop'),
                          const SizedBox(height: 12),
                          if (state.activeBatch != null)
                            ActiveBatchCard(
                              batch: state.activeBatch!,
                              onTap: () => context.push(
                                '/crop-management/batch/${state.activeBatch!.batchId}',
                              ),
                            )
                          else
                            _buildNoBatchCard(),

                          const SizedBox(height: 24),

                          // Quick Actions (OLD - Better with 4 actions)
                          _buildSectionHeader(context, 'Quick Actions'),
                          const SizedBox(height: 12),
                          _buildQuickActionsScroll(context),

                          const SizedBox(
                              height: 90), // Bottom nav + FAB padding
                        ]),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: Text('Unknown state'));
          },
        ),
      ),
      // OLD: Bottom Navigation Bar (PRD Required)
      bottomNavigationBar:
          const ChilliGuardBottomNavigationBar(currentIndex: 0),
      // Floating Action Button for Disease Detection
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/disease-detection'),
        tooltip: 'Detect Disease',
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // NEW: Enhanced Sliver App Bar (Zepto-style)
  Widget _buildAppBar(BuildContext context, DashboardLoaded state) {
    return SliverAppBar(
      floating: true,
      snap: true,
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ChilliGuard',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            'Field Alpha', // TODO: Dynamic field name
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                ),
          ),
        ],
      ),
      actions: [
        // Field Selector
        IconButton(
          icon: const Icon(Icons.location_on, color: Colors.white),
          tooltip: 'Change Field',
          onPressed: () {
            // TODO: Show field selector dialog
          },
        ),
        // Notifications with Badge
        Stack(
          children: [
            IconButton(
              icon:
                  const Icon(Icons.notifications_outlined, color: Colors.white),
              tooltip: 'Notifications',
              onPressed: () => context.push('/alerts'),
            ),
            if (state.recentAlerts.isNotEmpty)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '${state.recentAlerts.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        // More Options Menu
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onSelected: (value) {
            if (value == 'field_management') {
              context.push('/field-management');
            } else if (value == 'settings') {
              context.push('/settings');
            }
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem(
              value: 'field_management',
              child: Text('Manage Fields'),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: Text('Settings'),
            ),
          ],
        ),
      ],
    );
  }

  // NEW: Enhanced Alert Section
  Widget _buildAlertsSection(DashboardLoaded state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red[700]),
              const SizedBox(width: 8),
              Text(
                'Critical Alerts',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[900],
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => context.push('/alerts'),
                child:
                    Text('View All', style: TextStyle(color: Colors.red[700])),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...state.recentAlerts.take(3).map((alert) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: AlertListItem(
                  alert: alert,
                  onTap: () => context.push('/alerts'),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
    );
  }

  // NEW: 2x3 Comprehensive Sensor Grid
  Widget _buildSensorGrid(sensorReading) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        SensorCard(
          title: 'pH Level',
          value: sensorReading.ph.toStringAsFixed(1),
          unit: '',
          icon: Icons.science,
          status: _getSensorStatus(sensorReading.ph, 5.5, 7.5),
        ),
        SensorCard(
          title: 'Nitrogen (N)',
          value: sensorReading.nitrogen.toStringAsFixed(0),
          unit: 'ppm',
          icon: Icons.grass,
          status: _getSensorStatus(sensorReading.nitrogen, 100, 150),
        ),
        SensorCard(
          title: 'Phosphorus (P)',
          value: sensorReading.phosphorus.toStringAsFixed(0),
          unit: 'ppm',
          icon: Icons.local_florist,
          status: _getSensorStatus(sensorReading.phosphorus, 50, 75),
        ),
        SensorCard(
          title: 'Potassium (K)',
          value: sensorReading.potassium.toStringAsFixed(0),
          unit: 'ppm',
          icon: Icons.spa,
          status: _getSensorStatus(sensorReading.potassium, 50, 100),
        ),
        SensorCard(
          title: 'Moisture',
          value: sensorReading.moisture.toStringAsFixed(0),
          unit: '%',
          icon: Icons.water_drop,
          status: _getSensorStatus(sensorReading.moisture, 60, 70),
        ),
        SensorCard(
          title: 'Temperature',
          value: sensorReading.temperature.toStringAsFixed(1),
          unit: '°C',
          icon: Icons.thermostat,
          status: _getSensorStatus(sensorReading.temperature, 20, 30),
        ),
      ],
    );
  }

  SensorStatus _getSensorStatus(double value, double min, double max) {
    if (value >= min && value <= max) return SensorStatus.optimal;
    if (value >= min * 0.85 && value <= max * 1.15) {
      return SensorStatus.acceptable;
    }
    return SensorStatus.critical;
  }

  Widget _buildNoBatchCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.eco, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Active Crop',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start tracking a new crop batch',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => context.push('/crop-management/new'),
            icon: const Icon(Icons.add),
            label: const Text('Create New Batch'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  // OLD: Horizontal Scroll Quick Actions (Better UX for farmers)
  Widget _buildQuickActionsScroll(BuildContext context) {
    final actions = [
      {
        'icon': Icons.camera_alt,
        'label': 'Detect Disease',
        'route': '/disease-detection',
        'color': Colors.green,
      },
      {
        'icon': Icons.analytics,
        'label': 'View Reports',
        'route': '/reports',
        'color': Colors.amber,
      },
      {
        'icon': Icons.book,
        'label': 'Learn',
        'route': '/knowledge-base',
        'color': Colors.blue,
      },
      {
        'icon': Icons.history,
        'label': 'History',
        'route': '/crop-batches',
        'color': Colors.purple,
      },
    ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final action = actions[index];
          return Container(
            width: 90,
            margin: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () => context.push(action['route'] as String),
              borderRadius: BorderRadius.circular(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: (action['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      action['icon'] as IconData,
                      size: 28,
                      color: action['color'] as Color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    action['label'] as String,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
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
            'Error Loading Dashboard',
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
            onPressed: _loadDashboard,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }
}
