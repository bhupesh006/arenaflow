import 'package:flutter_test/flutter_test.dart';
import 'package:arena_flow/features/queue_tracker/presentation/bloc/queue_bloc.dart';
import 'package:arena_flow/features/queue_tracker/presentation/bloc/queue_event.dart';
import 'package:arena_flow/features/queue_tracker/presentation/bloc/queue_state.dart';

void main() {
  group('QueueBloc Tests', () {
    late QueueBloc queueBloc;

    setUp(() {
      queueBloc = QueueBloc();
    });

    tearDown(() {
      queueBloc.close();
    });

    test('Initial state is QueueInitial', () {
      expect(queueBloc.state, isA<QueueInitial>());
    });

    test('Emits [QueueLoading, QueueLoaded] exactly in order logically when FetchQueuesEvent is added', () async {
      // Create a list of expected states
      final expectedStates = [
        isA<QueueLoading>(),
        isA<QueueLoaded>(),
      ];

      expectLater(
        queueBloc.stream,
        emitsInOrder(expectedStates),
      );

      queueBloc.add(FetchQueuesEvent());
    });

    test('SearchQueuesEvent accurately filters memory repository', () async {
      queueBloc.add(FetchQueuesEvent());
      
      // Allow async initial load to resolve before we invoke search
      await Future.delayed(const Duration(milliseconds: 700));
      expect(queueBloc.state, isA<QueueLoaded>());
      
      // Filter the standings for pizza
      queueBloc.add(SearchQueuesEvent('Pizza'));
      
      // Wait for synchronous bloc state update
      await Future.delayed(const Duration(milliseconds: 50));
      
      final currentState = queueBloc.state;
      expect(currentState, isA<QueueLoaded>());
      
      final loadedState = currentState as QueueLoaded;
      expect(loadedState.stands.length, 1);
      expect(loadedState.stands.first['name'], 'Stadium Pizza');
    });
  });
}
