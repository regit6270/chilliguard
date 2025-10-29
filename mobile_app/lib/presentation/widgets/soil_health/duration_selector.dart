import 'package:flutter/material.dart';

class DurationSelector extends StatelessWidget {
  final String selectedDuration;
  final Function(String) onDurationChanged;

  const DurationSelector({
    super.key,
    required this.selectedDuration,
    required this.onDurationChanged,
  });

  @override
  Widget build(BuildContext context) {
    final durations = [
      {'id': '7d', 'label': '7 Days'},
      {'id': '14d', 'label': '14 Days'},
      {'id': '30d', 'label': '30 Days'},
      {'id': '90d', 'label': '90 Days'},
    ];

    return Row(
      children: durations.map((duration) {
        final isSelected = selectedDuration == duration['id'];
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: SizedBox(
                width: double.infinity,
                child: Text(
                  duration['label'] as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onDurationChanged(duration['id'] as String);
                }
              },
              selectedColor: Theme.of(context).colorScheme.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
              backgroundColor: Colors.grey[100],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
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
