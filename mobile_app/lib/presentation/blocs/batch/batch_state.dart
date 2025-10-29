part of 'batch_bloc.dart';

abstract class BatchState extends Equatable {
  const BatchState();

  @override
  List<Object?> get props => [];
}

class BatchInitial extends BatchState {}

class BatchLoading extends BatchState {}

class BatchesLoaded extends BatchState {
  final List<CropBatch> batches;
  final CropBatch? activeBatch;

  const BatchesLoaded({
    required this.batches,
    this.activeBatch,
  });

  @override
  List<Object?> get props => [batches, activeBatch];
}

class BatchDetailsLoaded extends BatchState {
  final CropBatch batch;

  const BatchDetailsLoaded(this.batch);

  @override
  List<Object> get props => [batch];
}

class BatchCreating extends BatchState {}

class BatchCreated extends BatchState {
  final String batchId;

  const BatchCreated(this.batchId);

  @override
  List<Object> get props => [batchId];
}

class BatchUpdating extends BatchState {}

class BatchUpdated extends BatchState {}

class BatchError extends BatchState {
  final String message;

  const BatchError(this.message);

  @override
  List<Object> get props => [message];
}
