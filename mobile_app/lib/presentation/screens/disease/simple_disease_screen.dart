// lib/features/camera/simple_disease_detection_screen.dart
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
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
  bool _showRaw = false;

  static const String BACKEND_URL =
      '${AppConstants.baseUrl}/api/v1/disease/detect';

  @override
  void initState() {
    super.initState();
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  Future<void> _pick(ImageSource s) async {
    try {
      final XFile? f = await _picker.pickImage(
        source: s,
        imageQuality: 85,
        maxWidth: 2000,
        maxHeight: 2000,
      );
      if (f == null) return;
      setState(() {
        _selectedImage = File(f.path);
        _detectionResult = null;
      });
    } catch (e) {
      _showSnack('Error picking image: $e', isError: true);
    }
  }

  Future<void> _uploadAndDetect() async {
    if (_selectedImage == null) {
      _showSnack('Please select an image first', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
      _detectionResult = null;
      _showRaw = false;
    });

    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          _selectedImage!.path,
          filename: 'leaf_${DateTime.now().millisecondsSinceEpoch}.jpg',
          contentType: MediaType('image', 'jpeg'),
        ),
        'user_id': 'demo_user_001',
        'field_id': 'field_123',
      });

      final resp = await _dio.post(
        BACKEND_URL,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (resp.statusCode == 200) {
        final data = resp.data is Map
            ? Map<String, dynamic>.from(resp.data)
            : {'raw': resp.data};
        if ((data['status'] == 'error') || (data['error'] != null)) {
          _showSnack(
              data['message']?.toString() ??
                  data['error']?.toString() ??
                  'Detection failed',
              isError: true);
        } else {
          setState(() => _detectionResult = data);
        }
      } else {
        _showSnack('Server error: ${resp.statusCode}', isError: true);
      }
    } on DioException catch (e) {
      String msg = 'Connection error';
      if (e.type == DioExceptionType.connectionTimeout) {
        msg = 'Connection timeout';
      } else if (e.response != null && e.response?.data != null) {
        final d = e.response?.data;
        if (d is Map && d['error'] != null) msg = d['error'].toString();
      }
      _showSnack(msg, isError: true);
    } catch (e) {
      _showSnack('Error: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnack(String text, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(text),
          backgroundColor: isError ? Colors.red : Colors.green),
    );
  }

  Color _severityColor(String? s) {
    switch (s?.toLowerCase()) {
      case 'critical':
        return Colors.red.shade700;
      case 'high':
        return Colors.deepOrange.shade700;
      case 'medium':
        return Colors.amber.shade800;
      case 'low':
        return Colors.green.shade700;
      default:
        return Colors.blueGrey.shade700;
    }
  }

  String _prettyRaw() {
    if (_detectionResult == null) return '';
    try {
      return const JsonEncoder.withIndent('  ').convert(_detectionResult);
    } catch (_) {
      return _detectionResult.toString();
    }
  }

  Widget _treatmentTile(dynamic item) {
    if (item is Map) {
      final name = item['name'] ?? '';
      final type = item['type'] ?? '';
      final dosage = item['dosage'] ?? '';
      final frequency = item['frequency'] ?? '';
      final desc = item['description'] ?? '';

      // Color and icon based on treatment type
      Color typeColor;
      IconData typeIcon;
      switch (type.toString().toLowerCase()) {
        case 'chemical':
          typeColor = Colors.deepPurple;
          typeIcon = Icons.science_outlined;
          break;
        case 'organic':
          typeColor = Colors.green;
          typeIcon = Icons.eco_outlined;
          break;
        case 'foliar spray':
          typeColor = Colors.blue;
          typeIcon = Icons.water_drop_outlined;
          break;
        case 'micronutrients':
          typeColor = Colors.orange;
          typeIcon = Icons.local_florist_outlined;
          break;
        default:
          typeColor = Colors.grey;
          typeIcon = Icons.medical_services_outlined;
      }

      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: typeColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: typeColor.withOpacity(0.3), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with type badge and name
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(typeIcon, size: 16, color: typeColor),
                      const SizedBox(width: 6),
                      Text(
                        type.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: typeColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (name.toString().isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                name.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],

            // Description
            if (desc.toString().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                desc.toString(),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
            ],

            // Dosage and Frequency info
            if (dosage.toString().isNotEmpty ||
                frequency.toString().isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    if (dosage.toString().isNotEmpty)
                      Row(
                        children: [
                          Icon(Icons.straighten_outlined,
                              size: 18, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          Text(
                            'Dosage: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                              fontSize: 13,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              dosage.toString(),
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    if (dosage.toString().isNotEmpty &&
                        frequency.toString().isNotEmpty)
                      const SizedBox(height: 6),
                    if (frequency.toString().isNotEmpty)
                      Row(
                        children: [
                          Icon(Icons.schedule_outlined,
                              size: 18, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          Text(
                            'Frequency: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                              fontSize: 13,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              frequency.toString(),
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    }
    return Text(item.toString());
  }

  void _openPreview() {
    if (_selectedImage == null) return;
    showDialog(
      context: context,
      builder: (ctx) {
        final size = MediaQuery.of(ctx).size;
        final maxW = size.width * 0.94;
        final maxH = size.height * 0.84;
        return Dialog(
          insetPadding: const EdgeInsets.all(12),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: maxW, maxHeight: maxH, minWidth: 100, minHeight: 100),
            child: Column(
              children: [
                Expanded(
                  child: InteractiveViewer(
                    child: Image.file(_selectedImage!,
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: double.infinity),
                  ),
                ),
                TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Close')),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const imageHeight = 300.0;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text('Disease Detection'),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: CustomScrollView(
        slivers: [
          // SliverAppBar holds the image only. Disable its automatic leading and toolbar to avoid double back arrows.
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: false,
            floating: false,
            expandedHeight: imageHeight,
            backgroundColor: theme.scaffoldBackgroundColor,
            toolbarHeight: 0, // hide secondary toolbar
            flexibleSpace: FlexibleSpaceBar(
              background: GestureDetector(
                onTap: _selectedImage != null ? _openPreview : null,
                child: _selectedImage != null
                    ? Image.file(_selectedImage!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity)
                    : Container(
                        color: Colors.grey.shade100,
                        alignment: Alignment.center,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_outlined,
                                size: 56, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('No image selected'),
                          ],
                        ),
                      ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _pick(ImageSource.gallery),
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Gallery'),
                          style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _pick(ImageSource.camera),
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Camera'),
                          style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _selectedImage == null || _isLoading
                              ? null
                              : _uploadAndDetect,
                          icon: const Icon(Icons.search),
                          label: const Text('Detect'),
                          style: OutlinedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _selectedImage == null
                              ? null
                              : () => setState(() => _selectedImage = null),
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Clear'),
                          style: OutlinedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_isLoading) const LinearProgressIndicator(),
                  const SizedBox(height: 8),
                  if (_detectionResult != null) ...[
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Text(
                                '${((_detectionResult!['confidence'] ?? 0) * 100).toStringAsFixed(0)}%',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      _detectionResult!['disease_name'] ??
                                          'Unknown',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 6),
                                  if ((_detectionResult!['scientific_name']
                                              as String?)
                                          ?.isNotEmpty ??
                                      false)
                                    Text(
                                        _detectionResult!['scientific_name'] ??
                                            '',
                                        style: const TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 13)),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Chip(
                                          label: Text(
                                              _detectionResult!['severity']
                                                      ?.toString() ??
                                                  'Unknown',
                                              style: const TextStyle(
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 13)),
                                          backgroundColor:
                                              (_detectionResult!['severity']
                                                      is String)
                                                  ? _severityColor(
                                                          _detectionResult![
                                                                  'severity']
                                                              as String)
                                                      .withOpacity(0.15)
                                                  : Colors.grey.shade100,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    if ((_detectionResult!['description'] as String?)
                            ?.isNotEmpty ??
                        false)
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Text(_detectionResult!['description'] ?? ''),
                        ),
                      ),

                    const SizedBox(height: 12),

                    // Causes Section
                    if (_detectionResult!['causes'] is List &&
                        (_detectionResult!['causes'] as List).isNotEmpty)
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        color: Colors.red.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.coronavirus_outlined,
                                        color: Colors.red.shade700, size: 22),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Causes',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.red.shade900,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                ...(_detectionResult!['causes'] as List)
                                    .asMap()
                                    .entries
                                    .map((e) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 6),
                                            width: 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              color: Colors.red.shade700,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              e.value.toString(),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.red.shade900,
                                                height: 1.4,
                                              ),
                                            ),
                                          ),
                                        ]),
                                  );
                                }),
                              ]),
                        ),
                      ),

                    const SizedBox(height: 12),

                    if (_detectionResult!['symptoms'] is List &&
                        (_detectionResult!['symptoms'] as List).isNotEmpty)
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        color: Colors.orange.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.visibility_outlined,
                                        color: Colors.orange.shade700,
                                        size: 22),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Symptoms',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.orange.shade900,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                ...(_detectionResult!['symptoms'] as List)
                                    .asMap()
                                    .entries
                                    .map((e) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 6),
                                            width: 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              color: Colors.orange.shade700,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              e.value.toString(),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.orange.shade900,
                                                height: 1.4,
                                              ),
                                            ),
                                          ),
                                        ]),
                                  );
                                }),
                              ]),
                        ),
                      ),

                    const SizedBox(height: 12),

                    if (_detectionResult!['treatments'] is List &&
                        (_detectionResult!['treatments'] as List).isNotEmpty)
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.medical_services,
                                        color: Colors.green.shade700, size: 22),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Treatment Options',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.green.shade900,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                ...(_detectionResult!['treatments'] as List)
                                    .asMap()
                                    .entries
                                    .map((e) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _treatmentTile(e.value),
                                  );
                                }),
                              ]),
                        ),
                      ),

                    const SizedBox(height: 12),

                    if (_detectionResult!['recommendations'] is List &&
                        (_detectionResult!['recommendations'] as List)
                            .isNotEmpty)
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        color: Colors.purple.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.lightbulb_outline,
                                        color: Colors.purple.shade700,
                                        size: 22),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Recommendations',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.purple.shade900,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                ...(_detectionResult!['recommendations']
                                        as List)
                                    .asMap()
                                    .entries
                                    .map((e) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 6),
                                            width: 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              color: Colors.purple.shade700,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              e.value.toString(),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.purple.shade900,
                                                height: 1.4,
                                              ),
                                            ),
                                          ),
                                        ]),
                                  );
                                }),
                              ]),
                        ),
                      ),

                    const SizedBox(height: 12),

                    // Sources Section
                    if (_detectionResult!['sources'] is List &&
                        (_detectionResult!['sources'] as List).isNotEmpty)
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        color: Colors.blue.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.source_outlined,
                                        color: Colors.blue.shade700, size: 22),
                                    const SizedBox(width: 8),
                                    Text(
                                      'References & Sources',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.blue.shade900,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                ...(_detectionResult!['sources'] as List)
                                    .asMap()
                                    .entries
                                    .map((e) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: Colors.blue.shade200),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(Icons.article_outlined,
                                              size: 18,
                                              color: Colors.blue.shade600),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              e.value.toString(),
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.blue.shade900,
                                                height: 1.4,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ]),
                        ),
                      ),

                    const SizedBox(height: 12),

                    ExpansionTile(
                      title: const Text('Raw response'),
                      initiallyExpanded: _showRaw,
                      onExpansionChanged: (open) =>
                          setState(() => _showRaw = open),
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          color: Colors.grey.shade50,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SelectableText(
                              _prettyRaw(),
                              style: const TextStyle(
                                  fontFamily: 'monospace', fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ] else ...[
                    const SizedBox(height: 6),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Center(
                            child: Text(
                                'No detection results yet. Tap Detect to analyze the image.',
                                style: theme.textTheme.bodyMedium)),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
