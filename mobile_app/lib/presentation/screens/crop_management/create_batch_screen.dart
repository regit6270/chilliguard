import 'package:chilliguard/l10n/app_localizations.dart'; // ignore: unused_import
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateBatchScreen extends StatefulWidget {
  const CreateBatchScreen({super.key});

  @override
  State<CreateBatchScreen> createState() => _CreateBatchScreenState();
}

class _CreateBatchScreenState extends State<CreateBatchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _varietyController = TextEditingController();
  final _plantCountController = TextEditingController();

  String? _selectedField;
  DateTime? _startDate;
  int _expectedDuration = 120;

  @override
  void dispose() {
    _nameController.dispose();
    _varietyController.dispose();
    _plantCountController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      // TODO: Save batch via BLoC
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Batch created successfully'),
          backgroundColor: Colors.green,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      appBar: AppBar(
        title: Text(isHindi ? 'नया बैच बनाएं' : 'Create New Batch'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Batch Name
              _buildTextField(
                controller: _nameController,
                label: isHindi ? 'बैच नाम' : 'Batch Name',
                hint: isHindi
                    ? 'उदा: मिर्च बैच 2024-A'
                    : 'e.g., Chilli Batch 2024-A',
                icon: Icons.label,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return isHindi ? 'नाम दर्ज करें' : 'Enter batch name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Field Selector
              Text(
                isHindi ? 'खेत चुनें' : 'Select Field',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: _selectedField,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.agriculture),
                  hintText: isHindi ? 'खेत चुनें' : 'Choose field',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                items: [
                  DropdownMenuItem(
                    value: 'field_1',
                    child: Text(isHindi ? 'मुख्य खेत' : 'Main Field'),
                  ),
                  DropdownMenuItem(
                    value: 'field_2',
                    child: Text(isHindi ? 'उत्तरी खेत' : 'North Field'),
                  ),
                ],
                validator: (value) {
                  if (value == null) {
                    return isHindi ? 'खेत चुनें' : 'Select field';
                  }
                  return null;
                },
                onChanged: (value) => setState(() => _selectedField = value),
              ),

              const SizedBox(height: 20),

              // Variety
              _buildTextField(
                controller: _varietyController,
                label: isHindi ? 'किस्म' : 'Variety',
                hint: 'G4, Pusa Jwala',
                icon: Icons.eco,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return isHindi ? 'किस्म दर्ज करें' : 'Enter variety';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Plant Count
              _buildTextField(
                controller: _plantCountController,
                label: isHindi ? 'पौधों की संख्या' : 'Number of Plants',
                hint: '5000',
                icon: Icons.spa,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return isHindi ? 'संख्या दर्ज करें' : 'Enter count';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Start Date
              Text(
                isHindi ? 'रोपण तिथि' : 'Planting Date',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() => _startDate = date);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[50],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 12),
                      Text(
                        _startDate != null
                            ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                            : (isHindi ? 'तिथि चुनें' : 'Select date'),
                        style: TextStyle(
                          color: _startDate != null
                              ? Colors.black87
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Expected Duration
              Text(
                isHindi ? 'अपेक्षित अवधि (दिन)' : 'Expected Duration (days)',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Slider(
                value: _expectedDuration.toDouble(),
                min: 90,
                max: 150,
                divisions: 12,
                label: '$_expectedDuration ${isHindi ? 'दिन' : 'days'}',
                onChanged: (value) {
                  setState(() => _expectedDuration = value.toInt());
                },
              ),
              Text(
                '$_expectedDuration ${isHindi ? 'दिन' : 'days'}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 30),

              // Create Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _handleSave,
                  icon: const Icon(Icons.add_circle),
                  label: Text(
                    isHindi ? 'बैच बनाएं' : 'Create Batch',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
      ],
    );
  }
}
