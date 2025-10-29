part of 'batch_bloc.dart';

abstract class BatchEvent extends Equatable {
  const BatchEvent();

  @override
  List<Object?> get props => [];
}

class LoadBatches extends BatchEvent {
  final String? fieldId;
  final String? status;

  const LoadBatches({this.fieldId, this.status});

  @override
  List<Object?> get props => [fieldId, status];
}

class LoadBatchDetails extends BatchEvent {
  final String batchId;

  const LoadBatchDetails(this.batchId);

  @override
  List<Object> get props => [batchId];
}

class CreateBatch extends BatchEvent {
  final CropBatch batch;

  const CreateBatch(this.batch);

  @override
  List<Object> get props => [batch];
}

class UpdateBatch extends BatchEvent {
  final String batchId;
  final Map<String, dynamic> updates;

  const UpdateBatch(this.batchId, this.updates);

  @override
  List<Object> get props => [batchId, updates];
}

class RefreshBatches extends BatchEvent {
  final String? fieldId;

  const RefreshBatches({this.fieldId});

  @override
  List<Object?> get props => [fieldId];
}
