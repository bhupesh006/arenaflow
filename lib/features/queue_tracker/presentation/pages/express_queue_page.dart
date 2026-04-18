import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/queue_calculator.dart';
import '../bloc/queue_bloc.dart';
import '../bloc/queue_event.dart';
import '../bloc/queue_state.dart';
import 'package:go_router/go_router.dart';

class ExpressQueuePage extends StatelessWidget {
  const ExpressQueuePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QueueBloc()..add(FetchQueuesEvent()),
      child: const _ExpressQueueView(),
    );
  }
}

class _ExpressQueueView extends StatefulWidget {
  const _ExpressQueueView({Key? key}) : super(key: key);

  @override
  State<_ExpressQueueView> createState() => _ExpressQueueViewState();
}

class _ExpressQueueViewState extends State<_ExpressQueueView> {
  final TextEditingController _searchController = TextEditingController();
  bool _isInSeatDelivery = false; // Toggle state

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(BuildContext context, String query) {
    context.read<QueueBloc>().add(SearchQueuesEvent(query));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Express Queues', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment(value: false, label: Text('Stand Pickup'), icon: Icon(Icons.storefront)),
                      ButtonSegment(value: true, label: Text('In-Seat Delivery'), icon: Icon(Icons.airline_seat_recline_normal)),
                    ],
                    selected: {_isInSeatDelivery},
                    onSelectionChanged: (Set<bool> newSelection) {
                      setState(() {
                        _isInSeatDelivery = newSelection.first;
                      });
                    },
                    style: SegmentedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      selectedBackgroundColor: Theme.of(context).primaryColor.withOpacity(0.3),
                      selectedForegroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Theme.of(context).scaffoldBackgroundColor, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Semantics(
                label: 'Search for concession stands',
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => _onSearchChanged(context, val),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Search Stands',
                    labelStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.search, color: Colors.white70),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<QueueBloc, QueueState>(
                builder: (context, state) {
                  if (state is QueueLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is QueueLoaded) {
                    if (state.stands.isEmpty) {
                      return const Center(
                        child: Text('No stands found', style: TextStyle(color: Colors.white54)),
                      );
                    }
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      itemCount: state.stands.length,
                      prototypeItem: _QueueCard(name: 'Measure', timeMinutes: 0, isCongested: false, isDelivery: _isInSeatDelivery),
                      itemBuilder: (context, index) {
                        final stand = state.stands[index];
                        final waitTime = QueueCalculator.estimateWaitTimeMinutes(
                          personsInLine: stand['persons'] as int,
                          averageServiceTimeSeconds: stand['avgSeconds'] as int,
                          activeStaff: stand['staff'] as int,
                        );
                        return _QueueCard(
                          key: ValueKey(stand['name']),
                          name: stand['name'] as String,
                          timeMinutes: waitTime,
                          isCongested: waitTime > 15,
                          isDelivery: _isInSeatDelivery,
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QueueCard extends StatelessWidget {
  final String name;
  final int timeMinutes;
  final bool isCongested;
  final bool isDelivery;

  const _QueueCard({
    Key? key,
    required this.name,
    required this.timeMinutes,
    required this.isCongested,
    required this.isDelivery,
  }) : super(key: key);

  String _mappedImage(String standName) {
    if (standName.toLowerCase().contains("burger")) {
      return "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=1500&auto=format&fit=crop";
    } else if (standName.toLowerCase().contains("pizza")) {
      return "https://images.unsplash.com/photo-1513104890138-7c749659a591?q=80&w=1500&auto=format&fit=crop";
    } else if (standName.toLowerCase().contains("drink") || standName.toLowerCase().contains("bar")) {
      return "https://images.unsplash.com/photo-1536935338788-846bb9981813?q=80&w=1500&auto=format&fit=crop";
    }
    return "https://images.unsplash.com/photo-1555939594-58d7cb561ad1?q=80&w=1500&auto=format&fit=crop"; // Default Food
  }

  @override
  Widget build(BuildContext context) {
    final timeColor = isCongested 
      ? Theme.of(context).colorScheme.secondary 
      : Theme.of(context).primaryColor;

    return Semantics(
      label: 'Concession Stand $name, ${isDelivery ? 'Delivery expected in' : 'Wait time'} $timeMinutes minutes',
      child: Container(
        margin: const EdgeInsets.only(bottom: 24.0),
        height: 280, // Taller for premium imagery
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                _mappedImage(name),
                fit: BoxFit.cover,
              ),
              // Gradient for readability
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.8), Colors.black.withOpacity(0.1)],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(Icons.access_time_filled, color: timeColor, size: 18),
                                  const SizedBox(width: 6),
                                  Text(
                                    isDelivery ? 'Delivery in $timeMinutes mins' : '$timeMinutes mins wait',
                                    style: TextStyle(
                                      color: timeColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                  if (isCongested && !isDelivery) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text('BUSY', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w900)),
                                    )
                                  ]
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Semantics(
                      button: true,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.push('/checkout', extra: {'item': name, 'isDelivery': isDelivery});
                        },
                        icon: Icon(isDelivery ? Icons.airline_seat_recline_normal : Icons.bolt, size: 24),
                        label: Text(isDelivery ? 'ORDER TO SEAT' : 'EXPRESS ORDER'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 56), // Large sub-action height
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
