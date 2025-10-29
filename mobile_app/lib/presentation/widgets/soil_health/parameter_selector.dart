import 'package:flutter/material.dart';

class ParameterSelector extends StatelessWidget {
  final String selectedParameter;
  final Function(String) onParameterChanged;

  const ParameterSelector({
    super.key,
    required this.selectedParameter,
    required this.onParameterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final parameters = [
      {'id': 'ph', 'label': 'pH', 'icon': Icons.science},
      {'id': 'nitrogen', 'label': 'Nitrogen', 'icon': Icons.grass},
      {'id': 'phosphorus', 'label': 'Phosphorus', 'icon': Icons.local_florist},
      {'id': 'potassium', 'label': 'Potassium', 'icon': Icons.spa},
      {'id': 'moisture', 'label': 'Moisture', 'icon': Icons.water_drop},
      {'id': 'temperature', 'label': 'Temperature', 'icon': Icons.thermostat},
    ];

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: parameters.length,
        itemBuilder: (context, index) {
          final param = parameters[index];
          final isSelected = selectedParameter == param['id'];

          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 0 : 8,
              right: index == parameters.length - 1 ? 0 : 8,
            ),
            child: _buildParameterChip(
              context,
              label: param['label'] as String,
              icon: param['icon'] as IconData,
              isSelected: isSelected,
              onTap: () => onParameterChanged(param['id'] as String),
            ),
          );
        },
      ),
    );
  }

  Widget _buildParameterChip(
    BuildContext context, {
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color:
              isSelected ? Theme.of(context).colorScheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey[300]!,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[700],
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
