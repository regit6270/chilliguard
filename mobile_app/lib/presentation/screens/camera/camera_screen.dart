import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_constants.dart'; // ignore: unused_import
import '../../blocs/disease_detection/disease_detection_bloc.dart';
import '../../widgets/camera/confidence_indicator.dart';
import '../../widgets/camera/detection_result_card.dart'; // ignore: unused_import
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disease Detection'),
        actions: [
          // Model Selection Toggle
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              children: [
                Text(
                  _useCloudModel ? 'Cloud' : 'Device',
                  style: const TextStyle(fontSize: 12),
                ),
                Switch(
                  value: _useCloudModel,
                  onChanged: (value) {
                    setState(() {
                      _useCloudModel = value;
                    });
                  },
                  activeThumbColor: Colors.green,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.history),
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
                backgroundColor: Colors.red,
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
          if (state is ImageCapturing) {
            return const LoadingOverlay(message: 'Opening camera...');
          }

          if (state is DiseaseDetecting) {
            return _buildDetectingView(state.imageFile);
          }

          if (state is DiseaseDetected) {
            return _buildResultView(context, state);
          }

          if (state is ImageCaptured) {
            return _buildImagePreview(context, state.imageFile);
          }

          // Initial state - Capture options
          return _buildCaptureOptions(context);
        },
      ),
      bottomNavigationBar:
          const ChilliGuardBottomNavigationBar(currentIndex: 1),
    );
  }

  Widget _buildCaptureOptions(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Instructions
            Icon(
              Icons.photo_camera_outlined,
              size: 100,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'Capture Leaf Image',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              'Take a clear photo of the affected leaf for accurate disease detection',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),

            // Tips Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: Colors.blue[700]),
                      const SizedBox(width: 8),
                      Text(
                        'Tips for Best Results',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTipItem('Use natural daylight for clear images'),
                  _buildTipItem('Focus on the affected area of the leaf'),
                  _buildTipItem('Avoid shadows and blur'),
                  _buildTipItem('Fill frame with the leaf'),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Capture Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _captureImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt, size: 28),
                    label: const Text('Take Photo'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _captureImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library, size: 28),
                    label: const Text('From Gallery'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Model Info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _useCloudModel ? Colors.green[50] : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _useCloudModel ? Icons.cloud : Icons.phone_android,
                    size: 20,
                    color:
                        _useCloudModel ? Colors.green[700] : Colors.grey[700],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _useCloudModel
                        ? 'Using Cloud Model (Higher Accuracy)'
                        : 'Using On-Device Model (Faster)',
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          _useCloudModel ? Colors.green[700] : Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(Icons.check_circle, size: 16, color: Colors.blue[700]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13, color: Colors.blue[800]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(BuildContext context, File imageFile) {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.black,
            child: Center(
              child: Image.file(
                imageFile,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Image captured successfully!',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context
                            .read<DiseaseDetectionBloc>()
                            .add(ResetDetection());
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retake'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () => _analyzeImage(imageFile),
                      icon: const Icon(Icons.search),
                      label: const Text('Analyze Image'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetectingView(File imageFile) {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.black,
            child: Center(
              child: Image.file(
                imageFile,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(24),
          color: Colors.white,
          child: Column(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                _useCloudModel
                    ? 'Analyzing with Cloud Model...'
                    : 'Analyzing with On-Device Model...',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Text(
                'This may take a few seconds',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
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
        // Image with result overlay
        Expanded(
          child: Stack(
            children: [
              Container(
                color: Colors.black,
                child: Center(
                  child: Image.file(
                    state.imageFile,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              // Confidence Badge
              Positioned(
                top: 16,
                right: 16,
                child: ConfidenceIndicator(
                  confidence: detection.confidence,
                  modelType: detection.modelType,
                ),
              ),
            ],
          ),
        ),

        // Results Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Disease Name
              Row(
                children: [
                  Icon(
                    isHealthy
                        ? Icons.check_circle
                        : Icons.warning_amber_rounded,
                    size: 32,
                    color: isHealthy ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          detection.diseaseName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (!isHealthy) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              SeverityBadge(severity: detection.severity),
                              const SizedBox(width: 12),
                              Text(
                                '${detection.affectedAreaPercent.toStringAsFixed(0)}% affected',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Action Buttons
              if (!isHealthy) ...[
                ElevatedButton.icon(
                  onPressed: () {
                    context.push('/treatment-recommendations',
                        extra: detection.detectionId);
                  },
                  icon: const Icon(Icons.medical_services),
                  label: const Text('View Treatment Options'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
              ],

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Save to health log
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Saved to health log')),
                        );
                      },
                      icon: const Icon(Icons.bookmark_border),
                      label: const Text('Save'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context
                            .read<DiseaseDetectionBloc>()
                            .add(ResetDetection());
                      },
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Scan Again'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Feedback Option
              TextButton.icon(
                onPressed: () {
                  // Show feedback dialog
                  _showFeedbackDialog(context);
                },
                icon: const Icon(Icons.feedback_outlined, size: 18),
                label: const Text('Not Accurate? Report'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _captureImage(ImageSource source) {
    context.read<DiseaseDetectionBloc>().add(CaptureImage(source));
  }

  void _analyzeImage(File imageFile) {
    const userId = 'user_123'; // TODO: Get from auth service
    context.read<DiseaseDetectionBloc>().add(
          DetectDiseaseFromImage(
            imageFile: imageFile,
            userId: userId,
            useCloudModel: _useCloudModel,
          ),
        );
  }

  void _showFeedbackDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Inaccurate Result'),
        content: const Text(
          'Your feedback helps improve our detection accuracy. What is the actual disease?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Thank you for your feedback!')),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
