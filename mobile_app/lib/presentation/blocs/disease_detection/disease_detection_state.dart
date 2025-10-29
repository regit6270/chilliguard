part of 'disease_detection_bloc.dart';

abstract class DiseaseDetectionState extends Equatable {
  const DiseaseDetectionState();

  @override
  List<Object?> get props => [];
}

class DiseaseDetectionInitial extends DiseaseDetectionState {}

class ImageCapturing extends DiseaseDetectionState {}

class ImageCaptured extends DiseaseDetectionState {
  final File imageFile;

  const ImageCaptured(this.imageFile);

  @override
  List<Object> get props => [imageFile];
}

class DiseaseDetecting extends DiseaseDetectionState {
  final File imageFile;

  const DiseaseDetecting(this.imageFile);

  @override
  List<Object> get props => [imageFile];
}

class DiseaseDetected extends DiseaseDetectionState {
  final DiseaseDetection detection;
  final File imageFile;

  const DiseaseDetected({
    required this.detection,
    required this.imageFile,
  });

  @override
  List<Object> get props => [detection, imageFile];
}

class DetectionHistoryLoaded extends DiseaseDetectionState {
  final List<DiseaseDetection> history;

  const DetectionHistoryLoaded(this.history);

  @override
  List<Object> get props => [history];
}

class DiseaseDetectionError extends DiseaseDetectionState {
  final String message;

  const DiseaseDetectionError(this.message);

  @override
  List<Object> get props => [message];
}
