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
  static const _defaultFieldId = 'field_123';

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  void _loadDashboard() {
    context.read<DashboardBloc>().add(const LoadDashboardData(_defaultFieldId));
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
                  context.read<DashboardBloc>().add(const RefreshDashboardData(_defaultFieldId));
                  await Future.delayed(const Duration(milliseconds: 250));
                },
                child: CustomScrollView(
                  slivers: [
                    _buildAppBar(context, state),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          if (state.recentAlerts.isNotEmpty) _buildAlertsSection(state),
                          const SizedBox(height: 14),
                          _buildSectionHeader(context, 'Crop Readiness'),
                          const SizedBox(height: 12),
                          FeasibilityCard(
                            score: state.feasibilityScore,
                            status: state.feasibilityStatus,
                            onTap: () => context.push('/soil-health'),
                          ),
                          const SizedBox(height: 22),
                          _buildSectionHeader(context, 'Soil Health Snapshot'),
                          const SizedBox(height: 12),
                          if (state.latestSensorData != null) _buildSensorGrid(state.latestSensorData!),
                          if (state.latestSensorData != null) const SizedBox(height: 8),
                          if (state.latestSensorData != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                'Last updated: ${_formatTimestamp(state.latestSensorData!.timestamp)}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                              ),
                            ),
                          const SizedBox(height: 26),
                          _buildSectionHeader(context, 'Active Crop'),
                          const SizedBox(height: 12),
                          if (state.activeBatch != null)
                            ActiveBatchCard(
                              batch: state.activeBatch!,
                              onTap: () => context.push('/crop-management/batch/${state.activeBatch!.batchId}'),
                            )
                          else
                            _buildNoBatchCard(),
                          const SizedBox(height: 22),
                          _buildSectionHeader(context, 'Quick Actions'),
                          const SizedBox(height: 12),
                          _buildQuickActionsScroll(context),
                          const SizedBox(height: 130),
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
      bottomNavigationBar: const ChilliGuardBottomNavigationBar(currentIndex: 0),
      floatingActionButton: _buildCenteredFab(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildCenteredFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => context.push('/disease-detection'),
      backgroundColor: const Color(0xFF2F8E4F),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
        width: 52,
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: const Icon(Icons.camera_alt, size: 26, color: Colors.white),
      ),
    );
  }

  /// Compact, responsive appbar that avoids overflow when collapsed.
  SliverAppBar _buildAppBar(BuildContext context, DashboardLoaded state) {
    const Color deepGreen = Color(0xFF1F7A45);
    const Color lightGreen = Color(0xFF61B57C);

    return SliverAppBar(
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      // reduced expandedHeight
      expandedHeight: 96,
      // provide explicit collapsedHeight so system knows toolbar size
      collapsedHeight: 64,
      automaticallyImplyLeading: false,
      flexibleSpace: LayoutBuilder(builder: (ctx, constraints) {
        // constraints.maxHeight varies from collapsedHeight .. expandedHeight
        final bool isCollapsed = constraints.maxHeight <= 72; // threshold to switch to compact layout
        final titleStyle = isCollapsed
            ? Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)
            : Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w800);
        final subtitleStyle = Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70);

        return ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [deepGreen, lightGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))],
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                // reduce vertical padding in collapsed mode
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: isCollapsed ? 8 : 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // title section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Title - font size adapts by style above
                          Text('ChilliGuard', style: titleStyle),
                          // show subtitle only when not collapsed
                          if (!isCollapsed) const SizedBox(height: 4),
                          if (!isCollapsed) Text('Field Alpha', style: subtitleStyle),
                        ],
                      ),
                    ),

                    // Notifications
                    IconButton(
                      onPressed: () => context.push('/alerts'),
                      icon: const Icon(Icons.notifications_none, color: Colors.white),
                      tooltip: 'Alerts',
                      splashRadius: 20,
                    ),

                    // Profile avatar
                    GestureDetector(
                      onTap: () => context.push('/profile'),
                      child: Container(
                        margin: const EdgeInsets.only(left: 6),
                        width: isCollapsed ? 36 : 38,
                        height: isCollapsed ? 36 : 38,
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), shape: BoxShape.circle),
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(18))),
    );
  }

  Widget _buildAlertsSection(DashboardLoaded state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red.shade700),
              const SizedBox(width: 10),
              Text('Critical Alerts', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const Spacer(),
              TextButton(onPressed: () => context.push('/alerts'), child: const Text('View All')),
            ],
          ),
          const SizedBox(height: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 160),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final alert = state.recentAlerts[index];
                return AlertListItem(alert: alert, onTap: () => context.push('/alerts'));
              },
              separatorBuilder: (_, __) => const Divider(height: 0),
              itemCount: state.recentAlerts.length.clamp(0, 5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, color: Colors.black87),
    );
  }

  Widget _buildSensorGrid(sensorReading) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.35,
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
    if (value >= min * 0.85 && value <= max * 1.15) return SensorStatus.acceptable;
    return SensorStatus.critical;
  }

  Widget _buildNoBatchCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 6))
      ]),
      child: Column(
        children: [
          Icon(Icons.eco, size: 56, color: Colors.green.shade50),
          const SizedBox(height: 16),
          Text('No Active Crop', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Start tracking a new crop batch', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => context.push('/crop-management/new'),
            icon: const Icon(Icons.add),
            label: const Text('Create New Batch'),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsScroll(BuildContext context) {
    final actions = [
      {'icon': Icons.camera_alt, 'label': 'Detect Disease', 'route': '/disease-detection'},
      {'icon': Icons.analytics, 'label': 'View Reports', 'route': '/reports'},
      {'icon': Icons.book, 'label': 'Knowledge', 'route': '/knowledge-base'},
      {'icon': Icons.history, 'label': 'History', 'route': '/crop-batches'},
    ];

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final action = actions[index];
          return Container(
            width: 110,
            margin: EdgeInsets.only(right: index == actions.length - 1 ? 0 : 12),
            child: InkWell(
              onTap: () => context.push(action['route'] as String),
              borderRadius: BorderRadius.circular(12),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
                  child: Icon(action['icon'] as IconData, size: 26, color: Colors.green.shade700),
                ),
                const SizedBox(height: 8),
                Text(action['label'] as String, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
              ]),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 0),
        itemCount: actions.length,
      ),
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
        const SizedBox(height: 16),
        Text('Error Loading Dashboard', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 32), child: Text(message, textAlign: TextAlign.center)),
        const SizedBox(height: 24),
        ElevatedButton.icon(onPressed: _loadDashboard, icon: const Icon(Icons.refresh), label: const Text('Retry')),
      ]),
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
