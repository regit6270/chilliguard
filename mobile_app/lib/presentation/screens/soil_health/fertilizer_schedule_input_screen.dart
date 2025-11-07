import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../blocs/recommendation/recommendation_bloc.dart';
import '../../blocs/recommendation/recommendation_event.dart';

class FertilizerScheduleInputScreen extends StatefulWidget {
  const FertilizerScheduleInputScreen({super.key});

  @override
  State<FertilizerScheduleInputScreen> createState() =>
      _FertilizerScheduleInputScreenState();
}

class _FertilizerScheduleInputScreenState
    extends State<FertilizerScheduleInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fieldAreaController = TextEditingController(text: '1.0');
  DateTime _plantingDate = DateTime.now();
  String _varietyType = 'hybrid';

  @override
  void dispose() {
    _fieldAreaController.dispose();
    super.dispose();
  }

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _plantingDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.green[600]!,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _plantingDate) {
      setState(() {
        _plantingDate = picked;
      });
    }
  }

  void _generateSchedule() {
    if (_formKey.currentState!.validate()) {
      final fieldArea = double.parse(_fieldAreaController.text);
      final plantingDateStr = DateFormat('yyyy-MM-dd').format(_plantingDate);

      // Dispatch event to BLoC
      context.read<RecommendationBloc>().add(
            LoadFertilizerSchedule(
              plantingDate: plantingDateStr,
              fieldArea: fieldArea,
              cropType: 'chilli',
              varietyType: _varietyType,
            ),
          );

      // Navigate to result screen
      context.push('/fertilizer-schedule-result');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      appBar: AppBar(
        title: Text(isHindi ? 'उर्वरक कार्यक्रम' : 'Fertilizer Schedule'),
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Icon
              Center(
                child: Icon(
                  Icons.agriculture,
                  size: 80,
                  color: Colors.green[300],
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                isHindi
                    ? 'अपनी फसल के लिए उर्वरक योजना बनाएं'
                    : 'Create Fertilizer Plan for Your Crop',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                isHindi
                    ? 'खेत की जानकारी दें और अनुकूलित उर्वरक कार्यक्रम प्राप्त करें'
                    : 'Enter field details to get customized fertilizer schedule',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Planting Date
              _buildInputLabel(
                  isHindi ? 'रोपण की तिथि' : 'Planting Date', Icons.event),
              Card(
                elevation: 1,
                child: ListTile(
                  leading: Icon(Icons.calendar_today, color: Colors.green[700]),
                  title: Text(
                    DateFormat('dd MMMM yyyy').format(_plantingDate),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    isHindi ? 'रोपण/बुवाई की तिथि' : 'Date of transplanting',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  trailing: Icon(Icons.edit, color: Colors.green[700]),
                  onTap: _selectDate,
                ),
              ),
              const SizedBox(height: 20),

              // Field Area
              _buildInputLabel(
                  isHindi ? 'खेत का क्षेत्रफल' : 'Field Area', Icons.landscape),
              TextFormField(
                controller: _fieldAreaController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.green[600]!, width: 2),
                  ),
                  prefixIcon: Icon(Icons.landscape, color: Colors.green[700]),
                  suffixText: isHindi ? 'हेक्टेयर' : 'hectares',
                  suffixStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w600,
                  ),
                  hintText: '1.0',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return isHindi
                        ? 'कृपया क्षेत्रफल दर्ज करें'
                        : 'Please enter field area';
                  }
                  final area = double.tryParse(value);
                  if (area == null || area <= 0) {
                    return isHindi
                        ? 'मान्य क्षेत्रफल दर्ज करें'
                        : 'Enter valid field area';
                  }
                  if (area > 100) {
                    return isHindi
                        ? '100 हेक्टेयर से कम दर्ज करें'
                        : 'Maximum 100 hectares';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Variety Type
              _buildInputLabel(isHindi ? 'मिर्च की किस्म' : 'Chilli Variety',
                  Icons.category),
              Card(
                elevation: 1,
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: Text(isHindi ? 'हाइब्रिड' : 'Hybrid'),
                      subtitle: Text(
                        isHindi
                            ? 'उच्च उपज (25-30 टन/हेक्टेयर)'
                            : 'High yield (25-30 tons/ha)',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      value: 'hybrid',
                      groupValue: _varietyType,
                      activeColor: Colors.green[700],
                      onChanged: (value) {
                        setState(() {
                          _varietyType = value!;
                        });
                      },
                    ),
                    Divider(height: 1, color: Colors.grey[300]),
                    RadioListTile<String>(
                      title: Text(isHindi ? 'स्थानीय' : 'Local'),
                      subtitle: Text(
                        isHindi
                            ? 'मध्यम उपज (18-22 टन/हेक्टेयर)'
                            : 'Medium yield (18-22 tons/ha)',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      value: 'local',
                      groupValue: _varietyType,
                      activeColor: Colors.green[700],
                      onChanged: (value) {
                        setState(() {
                          _varietyType = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.green[700]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        isHindi
                            ? 'आपको विस्तृत उर्वरक कार्यक्रम प्राप्त होगा'
                            : 'You will receive a detailed fertilizer schedule',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.green[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Generate Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _generateSchedule,
                  icon: const Icon(Icons.schedule, size: 24),
                  label: Text(
                    isHindi ? 'कार्यक्रम बनाएं' : 'Generate Schedule',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.green[700]),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
