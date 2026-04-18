import 'package:equatable/equatable.dart';

abstract class QueueEvent extends Equatable {
  const QueueEvent();

  @override
  List<Object> get props => [];
}

class FetchQueuesEvent extends QueueEvent {}

class SearchQueuesEvent extends QueueEvent {
  final String query;
  const SearchQueuesEvent(this.query);

  @override
  List<Object> get props => [query];
}
