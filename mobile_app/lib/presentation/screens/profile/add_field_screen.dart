import 'package:chilliguard/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddFieldScreen extends StatefulWidget {
  const AddFieldScreen({super.key});

  @override
  State<AddFieldScreen> createState() => _AddFieldScreenState();
}

class _AddFieldScreenState extends State<AddFieldScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _areaController = TextEditingController();
  final _locationController = TextEditingController();
  final _pincodeController = TextEditingController();

  String _selectedCrop = 'chilli';
  String _selectedSoilType = 'loam';

  @override
  void dispose() {
    _nameController.dispose();
    _areaController.dispose();
    _locationController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      // TODO: Save field to repository
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Field added successfully'),
          backgroundColor: Colors.green,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!; // ignore: unused_local_variable
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      appBar: AppBar(
        title: Text(isHindi ? 'खेत जोड़ें' : 'Add Field'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Field Name
              _buildTextField(
                controller: _nameController,
                label: isHindi ? 'खेत का नाम' : 'Field Name',
                hint: isHindi ? 'उदा: मुख्य खेत' : 'e.g., Main Field',
                icon: Icons.label,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return isHindi ? 'नाम दर्ज करें' : 'Enter field name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Area
              _buildTextField(
                controller: _areaController,
                label: isHindi ? 'क्षेत्रफल (हेक्टेयर)' : 'Area (hectares)',
                hint: '2.5',
                icon: Icons.square_foot,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return isHindi ? 'क्षेत्रफल दर्ज करें' : 'Enter area';
                  }
                  if (double.tryParse(value) == null) {
                    return isHindi
                        ? 'मान्य संख्या दर्ज करें'
                        : 'Enter valid number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Location
              _buildTextField(
                controller: _locationController,
                label: isHindi ? 'स्थान' : 'Location',
                hint: isHindi ? 'गांव/शहर' : 'Village/City',
                icon: Icons.location_on,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return isHindi ? 'स्थान दर्ज करें' : 'Enter location';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Pincode
              _buildTextField(
                controller: _pincodeController,
                label: isHindi ? 'पिन कोड' : 'PIN Code',
                hint: '411001',
                icon: Icons.pin_drop,
                keyboardType: TextInputType.number,
                maxLength: 6,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return isHindi ? 'पिन कोड दर्ज करें' : 'Enter PIN code';
                  }
                  if (value.length != 6) {
                    return isHindi
                        ? 'मान्य पिन कोड दर्ज करें'
                        : 'Enter valid PIN code';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Crop Type Dropdown
              Text(
                isHindi ? 'फसल प्रकार' : 'Crop Type',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: _selectedCrop,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.agriculture),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                items: [
                  DropdownMenuItem(
                    value: 'chilli',
                    child: Text(isHindi ? 'मिर्च' : 'Chilli'),
                  ),
                  DropdownMenuItem(
                    value: 'tomato',
                    child: Text(isHindi ? 'टमाटर' : 'Tomato'),
                  ),
                  DropdownMenuItem(
                    value: 'potato',
                    child: Text(isHindi ? 'आलू' : 'Potato'),
                  ),
                ],
                onChanged: (value) {
                  setState(() => _selectedCrop = value!);
                },
              ),

              const SizedBox(height: 20),

              // Soil Type Dropdown
              Text(
                isHindi ? 'मिट्टी प्रकार' : 'Soil Type',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: _selectedSoilType,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.terrain),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                items: [
                  DropdownMenuItem(
                    value: 'loam',
                    child: Text(isHindi ? 'दोमट' : 'Loam'),
                  ),
                  DropdownMenuItem(
                    value: 'clay',
                    child: Text(isHindi ? 'चिकनी' : 'Clay'),
                  ),
                  DropdownMenuItem(
                    value: 'sandy',
                    child: Text(isHindi ? 'रेतीली' : 'Sandy'),
                  ),
                  DropdownMenuItem(
                    value: 'silt',
                    child: Text(isHindi ? 'गादी' : 'Silt'),
                  ),
                ],
                onChanged: (value) {
                  setState(() => _selectedSoilType = value!);
                },
              ),

              const SizedBox(height: 30),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _handleSave,
                  icon: const Icon(Icons.save),
                  label: Text(
                    isHindi ? 'खेत सहेजें' : 'Save Field',
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
    int? maxLength,
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
          maxLength: maxLength,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            counterText: '',
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
