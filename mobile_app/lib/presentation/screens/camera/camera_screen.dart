// lib/features/camera/camera_screen.dart
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../blocs/disease_detection/disease_detection_bloc.dart';
import '../../widgets/camera/confidence_indicator.dart';
import '../../widgets/camera/detection_result_card.dart';
import '../../widgets/camera/severity_badge.dart';
import '../../widgets/common/bottom_navigation_bar.dart';
import '../../widgets/common/loading_overlay.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool _useCloudModel = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        title: const Text('Disease Detection'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              children: [
                Text(_useCloudModel ? 'Cloud' : 'Device',
                    style: theme.textTheme.bodySmall),
                const SizedBox(width: 6),
                Transform.scale(
                  scale: 0.9,
                  child: Switch(
                    value: _useCloudModel,
                    onChanged: (v) => setState(() => _useCloudModel = v),
                    activeColor: Colors.white,
                    activeTrackColor: Colors.green,
                    inactiveTrackColor: Colors.grey.shade300,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: 'Detection History',
            onPressed: () => context.push('/disease-history'),
          ),
        ],
      ),
      body: BlocConsumer<DiseaseDetectionBloc, DiseaseDetectionState>(
        listener: (context, state) {
          if (state is DiseaseDetectionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: Colors.white,
                  onPressed: () => _captureImage(ImageSource.camera),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ImageCapturing) return const LoadingOverlay(message: 'Opening camera...');
          if (state is DiseaseDetecting) return _buildDetectingView(state.imageFile);
          if (state is DiseaseDetected) return _buildResultView(context, state);
          if (state is ImageCaptured) return _buildImagePreview(context, state.imageFile);
          return _buildCaptureOptions(context);
        },
      ),
      bottomNavigationBar: const ChilliGuardBottomNavigationBar(currentIndex: 1),
    );
  }

  Widget _buildCaptureOptions(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          // Hero-style header card
          _GlassCard(
            child: Column(
              children: [
                const Icon(Icons.photo_camera_rounded, size: 72),
                const SizedBox(height: 12),
                Text('Capture Leaf Image', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text('Take a clear photo of the affected leaf for accurate disease detection',
                    textAlign: TextAlign.center, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
                const SizedBox(height: 12),
              ],
            ),
          ),
          const SizedBox(height: 14),
          // Tips and buttons
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          const Icon(Icons.lightbulb_outline),
                          const SizedBox(width: 8),
                          Text('Tips for Best Results', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        ]),
                        const SizedBox(height: 10),
                        _tip('Use natural daylight for clear images'),
                        _tip('Focus on the affected area of the leaf'),
                        _tip('Avoid shadows and blur'),
                        _tip('Fill the frame with the leaf'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _captureImage(ImageSource.camera),
                          icon: const Icon(Icons.camera_alt_outlined),
                          label: const Text('Take Photo'),
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _captureImage(ImageSource.gallery),
                          icon: const Icon(Icons.photo_library_outlined),
                          label: const Text('Gallery'),
                          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Model info pill
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: _useCloudModel ? Colors.green.shade50 : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(_useCloudModel ? Icons.cloud_done : Icons.phone_android, size: 18, color: _useCloudModel ? Colors.green.shade700 : Colors.grey.shade700),
                        const SizedBox(width: 8),
                        Text(_useCloudModel ? 'Cloud Model — higher accuracy' : 'On-Device Model — faster', style: theme.textTheme.bodySmall),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget _tip(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle), child: const Icon(Icons.check, size: 14, color: Colors.green)),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
      ]),
    );
  }

  Widget _buildImagePreview(BuildContext context, File imageFile) {
    return Column(
      children: [
        Expanded(child: _ImageViewer(imageFile: imageFile)),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Theme.of(context).cardColor, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Image captured', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.read<DiseaseDetectionBloc>().add(ResetDetection()),
                    icon: const Icon(Icons.refresh_outlined),
                    label: const Text('Retake'),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () => _analyzeImage(imageFile),
                    icon: const Icon(Icons.search_rounded),
                    label: const Text('Analyze'),
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetectingView(File imageFile) {
    return Column(
      children: [
        Expanded(child: _ImageViewer(imageFile: imageFile)),
        Container(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              const SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(strokeWidth: 4),
              ),
              const SizedBox(height: 12),
              Text(_useCloudModel ? 'Analyzing with Cloud Model...' : 'Analyzing with On-Device Model...', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text('This may take a few seconds', style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResultView(BuildContext context, DiseaseDetected state) {
    final detection = state.detection;
    final isHealthy = detection.isHealthy;

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              _ImageViewer(imageFile: state.imageFile),
              Positioned(
                top: 18,
                right: 18,
                child: ConfidenceIndicator(confidence: detection.confidence, modelType: detection.modelType),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: Theme.of(context).cardColor, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, -3))]),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [
              Icon(isHealthy ? Icons.check_circle_rounded : Icons.warning_amber_rounded, size: 34, color: isHealthy ? Colors.green : Colors.orange),
              const SizedBox(width: 12),
              Expanded(child: Text(detection.diseaseName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
            ]),
            const SizedBox(height: 10),
            if (!isHealthy)
              Row(children: [
                SeverityBadge(severity: detection.severity),
                const SizedBox(width: 12),
                Text('${detection.affectedAreaPercent.toStringAsFixed(0)}% affected', style: TextStyle(color: Colors.grey[600])),
              ]),
            const SizedBox(height: 14),
            if (!isHealthy) ElevatedButton.icon(
              onPressed: () => context.push('/treatment-recommendations', extra: detection.detectionId),
              icon: const Icon(Icons.medical_services_outlined),
              label: const Text('View Treatment Options'),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: OutlinedButton.icon(onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved to health log'))); }, icon: const Icon(Icons.bookmark_border), label: const Text('Save'))),
              const SizedBox(width: 12),
              Expanded(child: OutlinedButton.icon(onPressed: () => context.read<DiseaseDetectionBloc>().add(ResetDetection()), icon: const Icon(Icons.camera_alt_outlined), label: const Text('Scan Again'))),
            ]),
            const SizedBox(height: 8),
            TextButton.icon(onPressed: () => _showFeedbackDialog(context), icon: const Icon(Icons.feedback_outlined, size: 18), label: const Text('Not Accurate? Report')),
          ]),
        ),
      ],
    );
  }

  void _captureImage(ImageSource source) {
    context.read<DiseaseDetectionBloc>().add(CaptureImage(source));
  }

  void _analyzeImage(File imageFile) {
    const userId = 'user_123';
    context.read<DiseaseDetectionBloc>().add(DetectDiseaseFromImage(imageFile: imageFile, userId: userId, useCloudModel: _useCloudModel));
  }

  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Inaccurate Result'),
        content: const Text('Your feedback helps improve our detection accuracy. What is the actual disease?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thank you for your feedback!')));
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

/// Small glass card for consistent look
class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.6), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white.withOpacity(0.5))),
          child: child,
        ),
      ),
    );
  }
}

class _ImageViewer extends StatelessWidget {
  final File imageFile;
  const _ImageViewer({required this.imageFile});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Hero(
          tag: imageFile.path,
          child: ClipRRect(borderRadius: BorderRadius.circular(6), child: Image.file(imageFile, fit: BoxFit.contain)),
        ),
      ),
    );
  }
}
