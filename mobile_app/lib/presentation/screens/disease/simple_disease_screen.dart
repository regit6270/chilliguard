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
      if (e.type == DioExceptionType.connectionTimeout) msg = 'Connection timeout';
      else if (e.response != null && e.response?.data != null) {
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
      SnackBar(content: Text(text), backgroundColor: isError ? Colors.red : Colors.green),
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
      final desc = item['description'] ?? '';
      final parts = <String>[];
      if (name.toString().isNotEmpty) parts.add(name.toString());
      if (type.toString().isNotEmpty) parts.add(type.toString());
      if (dosage.toString().isNotEmpty) parts.add('Dosage: ${dosage.toString()}');
      final summary = parts.join(' • ');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (summary.isNotEmpty)
            Text(summary, style: const TextStyle(fontWeight: FontWeight.bold)),
          if (desc.toString().isNotEmpty) const SizedBox(height: 6),
          if (desc.toString().isNotEmpty) Text(desc.toString()),
        ],
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
            constraints:
                BoxConstraints(maxWidth: maxW, maxHeight: maxH, minWidth: 100, minHeight: 100),
            child: Column(
              children: [
                Expanded(
                  child: InteractiveViewer(
                    child: Image.file(_selectedImage!, fit: BoxFit.contain, width: double.infinity, height: double.infinity),
                  ),
                ),
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
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
    final imageHeight = 300.0;

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
                    ? Image.file(_selectedImage!, fit: BoxFit.cover, width: double.infinity, height: double.infinity)
                    : Container(
                        color: Colors.grey.shade100,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.image_outlined, size: 56, color: Colors.grey),
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
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _pick(ImageSource.camera),
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Camera'),
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _selectedImage == null || _isLoading ? null : _uploadAndDetect,
                          icon: const Icon(Icons.search),
                          label: const Text('Detect'),
                          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _selectedImage == null ? null : () => setState(() => _selectedImage = null),
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Clear'),
                          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_isLoading) const LinearProgressIndicator(),
                  const SizedBox(height: 8),

                  if (_detectionResult != null) ...[
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_detectionResult!['disease_name'] ?? 'Unknown',
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 6),
                                  if ((_detectionResult!['scientific_name'] as String?)?.isNotEmpty ?? false)
                                    Text(_detectionResult!['scientific_name'] ?? '',
                                        style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13)),
                                  const SizedBox(height: 8),
                                  Wrap(spacing: 8, runSpacing: 6, children: [
                                    Chip(
                                      label: Text(_detectionResult!['severity']?.toString() ?? 'Unknown',
                                          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w700)),
                                      backgroundColor: (_detectionResult!['severity'] is String)
                                          ? _severityColor(_detectionResult!['severity'] as String).withOpacity(0.15)
                                          : Colors.grey.shade100,
                                    ),
                                    Chip(
                                      label: Text(
                                          '${(_detectionResult!['affected_area_percentage'] ?? 0).toStringAsFixed(1)}% affected',
                                          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w700)),
                                      backgroundColor: Colors.grey.shade100,
                                    ),
                                  ])
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    if ((_detectionResult!['description'] as String?)?.isNotEmpty ?? false)
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Text(_detectionResult!['description'] ?? ''),
                        ),
                      ),

                    const SizedBox(height: 12),

                    if (_detectionResult!['symptoms'] is List && (_detectionResult!['symptoms'] as List).isNotEmpty)
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            const Text('Symptoms', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            ...(_detectionResult!['symptoms'] as List).asMap().entries.map((e) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text('${e.key + 1}. ', style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Expanded(child: Text(e.value.toString())),
                                ]),
                              );
                            }),
                          ]),
                        ),
                      ),

                    const SizedBox(height: 12),

                    if (_detectionResult!['treatments'] is List && (_detectionResult!['treatments'] as List).isNotEmpty)
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            const Text('Treatments', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            ...(_detectionResult!['treatments'] as List).asMap().entries.map((e) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _treatmentTile(e.value),
                              );
                            }),
                          ]),
                        ),
                      ),

                    const SizedBox(height: 12),

                    if (_detectionResult!['recommendations'] is List && (_detectionResult!['recommendations'] as List).isNotEmpty)
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            const Text('Recommendations', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            ...(_detectionResult!['recommendations'] as List).asMap().entries.map((e) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text('${e.key + 1}. ', style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Expanded(child: Text(e.value.toString())),
                                ]),
                              );
                            }),
                          ]),
                        ),
                      ),

                    const SizedBox(height: 12),

                    ExpansionTile(
                      title: const Text('Raw response'),
                      initiallyExpanded: _showRaw,
                      onExpansionChanged: (open) => setState(() => _showRaw = open),
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          color: Colors.grey.shade50,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SelectableText(
                              _prettyRaw(),
                              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ] else ...[
                    const SizedBox(height: 6),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Center(child: Text('No detection results yet. Tap Detect to analyze the image.', style: theme.textTheme.bodyMedium)),
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
