import 'package:chilliguard/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/profile/field_card.dart';

class FieldManagementScreen extends StatelessWidget {
  const FieldManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!; // ignore: unused_local_variable
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    // Mock data - replace with actual data from repository
    final fields = [
      {
        'id': 'field_1',
        'name': isHindi ? 'मुख्य खेत' : 'Main Field',
        'location': isHindi ? 'पुणे, महाराष्ट्र' : 'Pune, Maharashtra',
        'area': '2.5 ha',
        'cropType': isHindi ? 'मिर्च' : 'Chilli',
        'health': 85.0,
        'sensorCount': 3,
      },
      {
        'id': 'field_2',
        'name': isHindi ? 'उत्तरी खेत' : 'North Field',
        'location': isHindi ? 'नासिक, महाराष्ट्र' : 'Nashik, Maharashtra',
        'area': '1.8 ha',
        'cropType': isHindi ? 'मिर्च' : 'Chilli',
        'health': 72.0,
        'sensorCount': 2,
      },
      {
        'id': 'field_3',
        'name': isHindi ? 'दक्षिणी खेत' : 'South Field',
        'location': isHindi ? 'सातारा, महाराष्ट्र' : 'Satara, Maharashtra',
        'area': '3.2 ha',
        'cropType': isHindi ? 'मिर्च' : 'Chilli',
        'health': 91.0,
        'sensorCount': 4,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(isHindi ? 'मेरे खेत' : 'My Fields'),
      ),
      body: fields.isEmpty
          ? _buildEmptyState(context, isHindi)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: fields.length,
              itemBuilder: (context, index) {
                final field = fields[index];
                return FieldCard(
                  name: field['name'] as String,
                  location: field['location'] as String,
                  area: field['area'] as String,
                  cropType: field['cropType'] as String,
                  health: field['health'] as double,
                  sensorCount: field['sensorCount'] as int,
                  onTap: () {
                    // TODO: Navigate to field details
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/profile/add-field'),
        icon: const Icon(Icons.add),
        label: Text(isHindi ? 'खेत जोड़ें' : 'Add Field'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isHindi) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.agriculture,
              size: 100,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 20),
            Text(
              isHindi ? 'कोई खेत नहीं' : 'No Fields',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              isHindi
                  ? 'शुरू करने के लिए अपना पहला खेत जोड़ें'
                  : 'Add your first field to get started',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
