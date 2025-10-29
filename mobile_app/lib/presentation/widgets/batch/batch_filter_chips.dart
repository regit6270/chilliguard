import 'package:flutter/material.dart';

class BatchFilterChips extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const BatchFilterChips({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filters = [
      {'id': 'active', 'label': 'Active', 'icon': Icons.eco},
      {'id': 'completed', 'label': 'Completed', 'icon': Icons.check_circle},
      {'id': 'all', 'label': 'All', 'icon': Icons.list},
    ];

    return Row(
      children: filters.map((filter) {
        final isSelected = selectedFilter == filter['id'];
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    filter['icon'] as IconData,
                    size: 16,
                    color: isSelected ? Colors.white : Colors.grey[700],
                  ),
                  const SizedBox(width: 4),
                  Text(filter['label'] as String),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onFilterChanged(filter['id'] as String);
                }
              },
              selectedColor: Theme.of(context).colorScheme.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              backgroundColor: Colors.grey[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey[300]!,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
