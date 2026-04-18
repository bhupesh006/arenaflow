import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/queue_calculator.dart';
import 'queue_event.dart';
import 'queue_state.dart';

class QueueBloc extends Bloc<QueueEvent, QueueState> {
  // Mock data representing a Firestore collection
  final List<Map<String, dynamic>> _repositoryStands = [
    {'name': 'Burger Dash', 'persons': 10, 'avgSeconds': 60, 'staff': 2},
    {'name': 'Stadium Pizza', 'persons': 45, 'avgSeconds': 90, 'staff': 3},
    {'name': 'Beer & Pretzels', 'persons': 20, 'avgSeconds': 45, 'staff': 1},
    {'name': 'Main Merch Store', 'persons': 60, 'avgSeconds': 120, 'staff': 5},
  ];

  QueueBloc() : super(QueueInitial()) {
    on<FetchQueuesEvent>(_onFetchQueues);
    on<SearchQueuesEvent>(_onSearchQueues);
  }

  Future<void> _onFetchQueues(FetchQueuesEvent event, Emitter<QueueState> emit) async {
    emit(QueueLoading());
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));
    emit(QueueLoaded(List.from(_repositoryStands)));
  }

  void _onSearchQueues(SearchQueuesEvent event, Emitter<QueueState> emit) {
    if (state is QueueLoaded || state is QueueInitial) {
      final safeQuery = QueueCalculator.sanitizeSearchInput(event.query).toLowerCase();
      
      if (safeQuery.isEmpty) {
        emit(QueueLoaded(List.from(_repositoryStands)));
        return;
      }

      final filtered = _repositoryStands.where((stand) {
        return (stand['name'] as String).toLowerCase().contains(safeQuery);
      }).toList();
      
      emit(QueueLoaded(filtered));
    }
  }
}
