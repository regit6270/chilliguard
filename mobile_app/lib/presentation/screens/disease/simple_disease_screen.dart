import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart'; // For MediaType
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_constants.dart';

class SimpleDiseaseDetectionScreen extends StatefulWidget {
  const SimpleDiseaseDetectionScreen({super.key});

  @override
  State<SimpleDiseaseDetectionScreen> createState() =>
      _SimpleDiseaseDetectionScreenState();
}

class _SimpleDiseaseDetectionScreenState
    extends State<SimpleDiseaseDetectionScreen> {
  final ImagePicker _picker = ImagePicker();
  final Dio _dio = Dio();

  File? _selectedImage;
  bool _isLoading = false;
  Map<String, dynamic>? _detectionResult;

  // ✅ Correct backend URL (baseUrl already includes /api/v1)
  static const String BACKEND_URL =
      '${AppConstants.baseUrl}/api/v1/disease/detect';
  //static const String USER_TOKEN = 'your-auth-token'; // Add your auth token

  @override
  void initState() {
    super.initState();
    _setupDio();
  }

  void _setupDio() {
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.headers = {
      //'Authorization': 'Bearer $USER_TOKEN',
    };
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _detectionResult = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('✅ Image selected'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      _showError('Error picking image: $e');
    }
  }

  Future<void> _uploadAndDetect() async {
    if (_selectedImage == null) {
      _showError('Please select an image first');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print('📤 Uploading image to: $BACKEND_URL');

      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          _selectedImage!.path,
          filename:
              'leaf_image_${DateTime.now().millisecondsSinceEpoch}.jpg', // ✅ Add filename
          contentType: MediaType('image', 'jpeg'), // ✅ Add content type
        ),
        'user_id': 'demo_user_001', // ✅ Match seed_data.py demo user
        'field_id': 'field_123', // ✅ Match seed_data.py demo field
        'batch_id': 'batch_123', // ✅ Match seed_data.py demo batch (optional)
      });

      final response = await _dio.post(
        BACKEND_URL,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      if (response.statusCode == 200) {
        // Check if backend returned an error status
        if (response.data is Map && response.data['status'] == 'error') {
          _showError(response.data['message'] ?? 'Detection failed');
          setState(() => _isLoading = false);
          return;
        }

        setState(() {
          _detectionResult = response.data;
          _isLoading = false;
        });
        print('✅ Detection successful: ${response.data}');
      } else {
        _showError('Server error: ${response.statusCode}');
        setState(() => _isLoading = false);
      }
    } on DioException catch (e) {
      String errorMsg = 'Connection error';
      if (e.response != null) {
        errorMsg = e.response?.data['error'] ?? 'Detection failed';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMsg = 'Connection timeout - check backend URL';
      }
      _showError(errorMsg);
      setState(() => _isLoading = false);
    } catch (e) {
      _showError('Error: $e');
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Color _getSeverityColor(String? severity) {
    switch (severity?.toLowerCase()) {
      case 'critical':
        return Colors.red;
      case 'high':
        return Colors.deepOrange;
      case 'medium':
        return Colors.amber;
      case 'low':
        return Colors.yellow;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disease Detection'),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Analyzing leaf...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ===== IMAGE DISPLAY =====
                  Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            _selectedImage != null ? Colors.green : Colors.grey,
                        width: 2,
                      ),
                      color: Colors.grey[100],
                    ),
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child:
                                Image.file(_selectedImage!, fit: BoxFit.cover),
                          )
                        : const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image_not_supported,
                                    size: 60, color: Colors.grey),
                                SizedBox(height: 10),
                                Text('No image selected'),
                              ],
                            ),
                          ),
                  ),
                  const SizedBox(height: 24),

                  // ===== BUTTONS =====
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _pickImageFromGallery,
                          icon: const Icon(Icons.image),
                          label: const Text('Gallery'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (_selectedImage != null)
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _uploadAndDetect,
                            icon: const Icon(Icons.search),
                            label: const Text('Detect'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ===== RESULTS DISPLAY =====
                  if (_detectionResult != null) ...[
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _detectionResult!['disease_name'] ??
                                            'Unknown',
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _detectionResult!['scientific_name'] ??
                                            '',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getSeverityColor(
                                      _detectionResult!['severity'],
                                    ).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: _getSeverityColor(
                                        _detectionResult!['severity'],
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    _detectionResult!['severity'] ?? 'Unknown',
                                    style: TextStyle(
                                      color: _getSeverityColor(
                                        _detectionResult!['severity'],
                                      ),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 20),

                            // Confidence
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Confidence:'),
                                Text(
                                  '${((_detectionResult!['confidence'] ?? 0) * 100).toStringAsFixed(1)}%',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Affected Area
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Affected Area:'),
                                Text(
                                  '${(_detectionResult!['affected_area_percentage'] ?? 0).toStringAsFixed(1)}%',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Description
                            Text(
                              _detectionResult!['description'] ?? '',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[700],
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ===== SYMPTOMS =====
                    if (_detectionResult!['symptoms'] != null &&
                        (_detectionResult!['symptoms'] as List).isNotEmpty)
                      _buildSection(
                        'Symptoms',
                        _detectionResult!['symptoms'],
                        Icons.warning,
                        Colors.orange,
                      ),
                    const SizedBox(height: 12),

                    // ===== TREATMENTS =====
                    if (_detectionResult!['treatments'] != null &&
                        (_detectionResult!['treatments'] as List).isNotEmpty)
                      _buildTreatmentSection(_detectionResult!['treatments']),
                    const SizedBox(height: 12),

                    // ===== RECOMMENDATIONS =====
                    if (_detectionResult!['recommendations'] != null &&
                        (_detectionResult!['recommendations'] as List)
                            .isNotEmpty)
                      _buildSection(
                        'Recommendations',
                        _detectionResult!['recommendations'],
                        Icons.lightbulb,
                        Colors.amber,
                      ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildSection(
    String title,
    List<dynamic> items,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...items.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${entry.key + 1}. ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Text(entry.value.toString()),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTreatmentSection(List<dynamic> treatments) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.healing, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Treatments',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...(treatments).asMap().entries.map((entry) {
              final treatment = entry.value as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Chip(
                          label: Text(
                            treatment['type'] ?? '',
                            style: const TextStyle(fontSize: 11),
                          ),
                          backgroundColor: Colors.green[100],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            treatment['name'] ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      treatment['description'] ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
