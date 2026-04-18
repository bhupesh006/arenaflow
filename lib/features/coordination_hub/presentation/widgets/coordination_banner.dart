import 'dart:ui';
import 'package:flutter/material.dart';

class CoordinationBanner extends StatelessWidget {
  const CoordinationBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mocked realtime alert
    const String mockAlert = "Gate B is congested, please use Gate C.";
    const bool isCritical = true;

    final Color alertColor = isCritical ? Theme.of(context).colorScheme.secondary : Theme.of(context).primaryColor;

    return Semantics(
      label: 'Real-time Coordination Alert: ${isCritical ? 'Critical Warning' : 'Information'}',
      value: mockAlert,
      excludeSemantics: true,
      liveRegion: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              decoration: BoxDecoration(
                color: alertColor.withOpacity(0.15), // Highly translucent glass background
                borderRadius: BorderRadius.circular(24.0),
                border: Border.all(color: alertColor.withOpacity(0.5), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10.0,
                    offset: const Offset(0, 4),
                  )
                ]
              ),
              child: Row(
                children: [
                  Icon(
                    isCritical ? Icons.warning_amber_rounded : Icons.info_outline,
                    color: alertColor,
                    size: 28,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      mockAlert,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.95),
                        fontWeight: FontWeight.w700,
                        fontSize: 15, // Sleek, modern readable size
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
