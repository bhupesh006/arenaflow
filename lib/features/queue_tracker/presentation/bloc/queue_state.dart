import 'package:equatable/equatable.dart';

abstract class QueueState extends Equatable {
  const QueueState();
  
  @override
  List<Object> get props => [];
}

class QueueInitial extends QueueState {}

class QueueLoading extends QueueState {}

class QueueLoaded extends QueueState {
  final List<Map<String, dynamic>> stands;
  
  const QueueLoaded(this.stands);

  @override
  List<Object> get props => [stands];
}

class QueueError extends QueueState {
  final String message;
  
  const QueueError(this.message);

  @override
  List<Object> get props => [message];
}
