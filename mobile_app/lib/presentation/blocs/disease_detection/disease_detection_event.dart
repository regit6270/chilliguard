part of 'disease_detection_bloc.dart';

abstract class DiseaseDetectionEvent extends Equatable {
  const DiseaseDetectionEvent();

  @override
  List<Object?> get props => [];
}

class CaptureImage extends DiseaseDetectionEvent {
  final ImageSource source; // camera or gallery

  const CaptureImage(this.source);

  @override
  List<Object> get props => [source];
}

class DetectDiseaseFromImage extends DiseaseDetectionEvent {
  final File imageFile;
  final String userId;
  final String? fieldId;
  final String? batchId;
  final bool useCloudModel; // false = on-device, true = cloud

  const DetectDiseaseFromImage({
    required this.imageFile,
    required this.userId,
    this.fieldId,
    this.batchId,
    this.useCloudModel = false,
  });

  @override
  List<Object?> get props =>
      [imageFile, userId, fieldId, batchId, useCloudModel];
}

class LoadDetectionHistory extends DiseaseDetectionEvent {
  final String? batchId;

  const LoadDetectionHistory({this.batchId});

  @override
  List<Object?> get props => [batchId];
}

class ResetDetection extends DiseaseDetectionEvent {}
