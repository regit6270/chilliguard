import 'package:flutter/material.dart';

class BatchTimelineWidget extends StatelessWidget {
  final DateTime plantingDate;
  final DateTime? harvestDate;
  final String currentStage;
  final List<Map<String, dynamic>> activities;

  const BatchTimelineWidget({
    super.key,
    required this.plantingDate,
    this.harvestDate,
    required this.currentStage,
    required this.activities,
  });

  @override
  Widget build(BuildContext context) {
    final stages = _getStages();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Growth Stages
        Text(
          'Growth Stage',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),

        // Stage Progress
        _buildStageProgress(context, stages),

        const SizedBox(height: 24),

        // Activity Timeline
        Text(
          'Recent Activities',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),

        // Activity List
        ...activities.map((activity) => _buildActivityItem(context, activity)),
      ],
    );
  }

  Widget _buildStageProgress(BuildContext context, List<String> stages) {
    final currentIndex = stages.indexOf(currentStage);

    return Row(
      children: stages.asMap().entries.map((entry) {
        final index = entry.key;
        final stage = entry.value;
        final isCompleted = index <= currentIndex;
        final isCurrent = index == currentIndex;

        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey[300],
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCurrent
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: Icon(
                        isCompleted ? Icons.check : Icons.circle,
                        color: isCompleted ? Colors.white : Colors.grey[600],
                        size: 20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stage,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight:
                            isCurrent ? FontWeight.bold : FontWeight.normal,
                        color: isCompleted ? Colors.black87 : Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              if (index < stages.length - 1)
                Expanded(
                  child: Container(
                    height: 2,
                    color: isCompleted
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey[300],
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActivityItem(
      BuildContext context, Map<String, dynamic> activity) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (activity['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              activity['icon'] as IconData,
              color: activity['color'] as Color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['title'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity['description'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity['time'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getStages() {
    return ['Seedling', 'Vegetative', 'Flowering', 'Fruiting', 'Harvest'];
  }
}
