import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import '../../../data/repositories/disease_repository.dart';
import '../../../domain/entities/disease_detection.dart';

part 'disease_detection_event.dart';
part 'disease_detection_state.dart';

@injectable
class DiseaseDetectionBloc
    extends Bloc<DiseaseDetectionEvent, DiseaseDetectionState> {
  final DiseaseRepository diseaseRepository;
  final ImagePicker _imagePicker = ImagePicker();

  DiseaseDetectionBloc({
    required this.diseaseRepository,
  }) : super(DiseaseDetectionInitial()) {
    on<CaptureImage>(_onCaptureImage);
    on<DetectDiseaseFromImage>(_onDetectDiseaseFromImage);
    on<LoadDetectionHistory>(_onLoadDetectionHistory);
    on<ResetDetection>(_onResetDetection);
  }

  Future<void> _onCaptureImage(
    CaptureImage event,
    Emitter<DiseaseDetectionState> emit,
  ) async {
    try {
      emit(ImageCapturing());

      final XFile? pickedFile = await _imagePicker.pickImage(
        source: event.source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        emit(ImageCaptured(imageFile));
      } else {
        emit(DiseaseDetectionInitial());
      }
    } catch (e) {
      emit(DiseaseDetectionError('Failed to capture image: ${e.toString()}'));
    }
  }

  Future<void> _onDetectDiseaseFromImage(
    DetectDiseaseFromImage event,
    Emitter<DiseaseDetectionState> emit,
  ) async {
    emit(DiseaseDetecting(event.imageFile));

    try {
      final result = event.useCloudModel
          ? await diseaseRepository.detectDiseaseCloud(
              imageFile: event.imageFile,
              userId: event.userId,
              fieldId: event.fieldId,
              batchId: event.batchId,
            )
          : await diseaseRepository.detectDisease(
              imageFile: event.imageFile,
              userId: event.userId,
              fieldId: event.fieldId,
              batchId: event.batchId,
            );

      result.fold(
        (failure) => emit(DiseaseDetectionError(failure.message)),
        (detection) => emit(DiseaseDetected(
          detection: detection,
          imageFile: event.imageFile,
        )),
      );
    } catch (e) {
      emit(DiseaseDetectionError('Detection failed: ${e.toString()}'));
    }
  }

  Future<void> _onLoadDetectionHistory(
    LoadDetectionHistory event,
    Emitter<DiseaseDetectionState> emit,
  ) async {
    try {
      final result = await diseaseRepository.getDetectionHistory(
        batchId: event.batchId,
      );

      result.fold(
        (failure) => emit(DiseaseDetectionError(failure.message)),
        (history) => emit(DetectionHistoryLoaded(history)),
      );
    } catch (e) {
      emit(DiseaseDetectionError('Failed to load history: ${e.toString()}'));
    }
  }

  Future<void> _onResetDetection(
    ResetDetection event,
    Emitter<DiseaseDetectionState> emit,
  ) async {
    emit(DiseaseDetectionInitial());
  }
}
