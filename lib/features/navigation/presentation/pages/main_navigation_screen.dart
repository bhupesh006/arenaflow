import 'package:flutter/material.dart';

import 'package:arena_flow/core/theme/app_theme.dart';
import 'package:arena_flow/features/map_routing/presentation/pages/smart_map_page.dart';
import 'package:arena_flow/features/queue_tracker/presentation/pages/express_queue_page.dart';
import 'package:arena_flow/features/coordination_hub/presentation/widgets/coordination_banner.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    SmartMapPage(),
    ExpressQueuePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Coordination Hub - Always visible banner system
            CoordinationBanner(),
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: _pages,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Semantics(
        label: 'Main Navigation Bar',
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: Semantics(
                label: 'Stadium Map Tab',
                child: const Icon(Icons.map_outlined),
              ),
              activeIcon: const Icon(Icons.map),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Semantics(
                label: 'Food and Amenities Queue Tab',
                child: const Icon(Icons.fastfood_outlined),
              ),
              activeIcon: const Icon(Icons.fastfood),
              label: 'Express',
            ),
          ],
        ),
      ),
    );
  }
}
