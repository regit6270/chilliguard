import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../data/repositories/batch_repository.dart';
import '../../../domain/entities/crop_batch.dart';

part 'batch_event.dart';
part 'batch_state.dart';

@injectable
class BatchBloc extends Bloc<BatchEvent, BatchState> {
  final BatchRepository batchRepository;

  BatchBloc({
    required this.batchRepository,
  }) : super(BatchInitial()) {
    on<LoadBatches>(_onLoadBatches);
    on<LoadBatchDetails>(_onLoadBatchDetails);
    on<CreateBatch>(_onCreateBatch);
    on<UpdateBatch>(_onUpdateBatch);
    on<RefreshBatches>(_onRefreshBatches);
  }

  Future<void> _onLoadBatches(
    LoadBatches event,
    Emitter<BatchState> emit,
  ) async {
    emit(BatchLoading());

    try {
      final result = await batchRepository.getBatches(
        fieldId: event.fieldId,
        status: event.status,
      );

      result.fold(
        (failure) => emit(BatchError(failure.message)),
        (batches) {
          // Find active batch
          final activeBatch = batches.firstWhere(
            (b) => b.status == 'active',
            orElse: () => batches.first,
          );

          emit(BatchesLoaded(
            batches: batches,
            activeBatch: batches.isNotEmpty ? activeBatch : null,
          ));
        },
      );
    } catch (e) {
      emit(BatchError('Failed to load batches: ${e.toString()}'));
    }
  }

  Future<void> _onLoadBatchDetails(
    LoadBatchDetails event,
    Emitter<BatchState> emit,
  ) async {
    emit(BatchLoading());

    try {
      final result = await batchRepository.getBatch(event.batchId);

      result.fold(
        (failure) => emit(BatchError(failure.message)),
        (batch) => emit(BatchDetailsLoaded(batch)),
      );
    } catch (e) {
      emit(BatchError('Failed to load batch details: ${e.toString()}'));
    }
  }

  Future<void> _onCreateBatch(
    CreateBatch event,
    Emitter<BatchState> emit,
  ) async {
    emit(BatchCreating());

    try {
      final result = await batchRepository.createBatch(event.batch);

      result.fold(
        (failure) => emit(BatchError(failure.message)),
        (batchId) {
          emit(BatchCreated(batchId));
          // Reload batches after creation
          add(LoadBatches(fieldId: event.batch.fieldId));
        },
      );
    } catch (e) {
      emit(BatchError('Failed to create batch: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateBatch(
    UpdateBatch event,
    Emitter<BatchState> emit,
  ) async {
    emit(BatchUpdating());

    try {
      final result = await batchRepository.updateBatch(
        event.batchId,
        event.updates,
      );

      result.fold(
        (failure) => emit(BatchError(failure.message)),
        (_) {
          emit(BatchUpdated());
          // Reload batch details after update
          add(LoadBatchDetails(event.batchId));
        },
      );
    } catch (e) {
      emit(BatchError('Failed to update batch: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshBatches(
    RefreshBatches event,
    Emitter<BatchState> emit,
  ) async {
    add(LoadBatches(fieldId: event.fieldId));
  }
}
