import 'package:flutter/material.dart';

class ComparisonCard extends StatelessWidget {
  final String parameterName;
  final String unit;
  final double yesterdayValue;
  final double todayValue;
  final IconData parameterIcon;
  final String optimalRange;

  const ComparisonCard({
    super.key,
    required this.parameterName,
    required this.unit,
    required this.yesterdayValue,
    required this.todayValue,
    required this.parameterIcon,
    required this.optimalRange,
  });

  @override
  Widget build(BuildContext context) {
    final change = todayValue - yesterdayValue;
    final changePercent = yesterdayValue != 0 
        ? ((change / yesterdayValue) * 100).abs() 
        : 0.0;
    
    final isImproving = _isChangePositive(change);
    final changeColor = _getChangeColor(change);
    final changeIcon = _getChangeIcon(change);
    final statusMessage = _getStatusMessage(isImproving, change);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: changeColor.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Parameter name with icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: changeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  parameterIcon,
                  color: changeColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      parameterName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Optimal: $optimalRange',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Comparison Section
          Row(
            children: [
              // Yesterday
              Expanded(
                child: _buildValueCard(
                  label: 'Yesterday',
                  value: _formatValue(yesterdayValue),
                  color: Colors.grey[400]!,
                ),
              ),
              const SizedBox(width: 12),

              // Arrow indicator
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: changeColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  changeIcon,
                  color: changeColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),

              // Today
              Expanded(
                child: _buildValueCard(
                  label: 'Today',
                  value: _formatValue(todayValue),
                  color: changeColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Divider
          Divider(color: Colors.grey[300], thickness: 1),
          const SizedBox(height: 12),

          // Change indicator and status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Change amount
              Row(
                children: [
                  Text(
                    'Change: ',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${change >= 0 ? '+' : ''}${_formatValue(change)} (${changePercent.toStringAsFixed(1)}%)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: changeColor,
                    ),
                  ),
                ],
              ),

              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: changeColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusMessage,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: changeColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Contextual message
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 16,
                  color: Colors.blue[700],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getContextualMessage(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[900],
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValueCard({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _formatValue(double value) {
    return '${value.toStringAsFixed(1)}$unit';
  }

  bool _isChangePositive(double change) {
    // For pH, small changes are normal; for others, increase is generally good
    switch (parameterName.toLowerCase()) {
      case 'ph level':
        return change.abs() < 0.3; // Stable pH is good
      case 'moisture':
      case 'nitrogen':
      case 'phosphorus':
      case 'potassium':
        return change >= 0; // Increase is good
      case 'temperature':
        return change.abs() < 2; // Stable temperature is good
      default:
        return change >= 0;
    }
  }

  Color _getChangeColor(double change) {
    if (change.abs() < 0.5 && parameterName.toLowerCase() != 'nitrogen') {
      return Colors.grey; // Stable/no significant change
    }

    if (_isChangePositive(change)) {
      return Colors.green; // Positive change
    } else {
      return Colors.orange; // Needs attention
    }
  }

  IconData _getChangeIcon(double change) {
    if (change.abs() < 0.5 && parameterName.toLowerCase() != 'nitrogen') {
      return Icons.horizontal_rule; // Stable
    }
    return change > 0 ? Icons.arrow_upward : Icons.arrow_downward;
  }

  String _getStatusMessage(bool isImproving, double change) {
    if (change.abs() < 0.5 && parameterName.toLowerCase() != 'nitrogen') {
      return 'STABLE';
    }
    
    if (isImproving) {
      return change > 0 ? 'IMPROVING' : 'GOOD';
    } else {
      return 'ATTENTION';
    }
  }

  String _getContextualMessage() {
    final change = todayValue - yesterdayValue;
    
    switch (parameterName.toLowerCase()) {
      case 'ph level':
        if (change.abs() < 0.2) {
          return 'pH is stable. Continue current soil management.';
        } else if (change > 0.2) {
          return 'pH increasing. Monitor closely if it exceeds 7.5.';
        } else {
          return 'pH decreasing. Consider lime application if below 5.5.';
        }

      case 'nitrogen':
        if (change >= 5) {
          return 'Nitrogen levels rising well. Fertilization effective.';
        } else if (change < 0) {
          return 'Nitrogen declining. Plan next fertilizer application.';
        } else {
          return 'Nitrogen stable. Monitor for next application timing.';
        }

      case 'phosphorus':
        if (change >= 3) {
          return 'Phosphorus improving. Good for root development.';
        } else if (change < 0) {
          return 'Phosphorus decreasing. Consider SSP/DAP application.';
        } else {
          return 'Phosphorus levels maintained well.';
        }

      case 'potassium':
        if (change >= 5) {
          return 'Potassium levels rising. Supports fruit quality.';
        } else if (change < 0) {
          return 'Potassium declining. Plan MOP application soon.';
        } else {
          return 'Potassium stable. Maintain current inputs.';
        }

      case 'moisture':
        if (change >= 5) {
          return 'Moisture increasing. Recent irrigation effective.';
        } else if (change < -5) {
          return 'Moisture dropping. Increase irrigation frequency.';
        } else {
          return 'Moisture levels stable. Continue current schedule.';
        }

      case 'temperature':
        if (todayValue > 30) {
          return 'Temperature high. Consider mulching to cool soil.';
        } else if (todayValue < 18) {
          return 'Temperature low. Monitor for stress symptoms.';
        } else {
          return 'Temperature in optimal range for chilli growth.';
        }

      default:
        return 'Monitor this parameter regularly.';
    }
  }
}
