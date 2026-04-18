import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:ui';

class SmartMapPage extends StatefulWidget {
  const SmartMapPage({Key? key}) : super(key: key);

  @override
  State<SmartMapPage> createState() => _SmartMapPageState();
}

class _SmartMapPageState extends State<SmartMapPage> {
  // MA Chidambaram Stadium (Chepauk) Center coordinates
  final LatLng _stadiumCenter = const LatLng(13.0628, 80.2793);
  final MapController _mapController = MapController();
  
  bool _isRoutingToExit = false;

  void _triggerEmergencyRouting() {
    setState(() => _isRoutingToExit = true);
    // Pan to fit the route
    _mapController.move(const LatLng(13.0632, 80.2798), 18.0);
  }

  // Helper to generate a rough circle/oval for the cricket field
  List<LatLng> _generateCricketOval(LatLng center, double radiusLat, double radiusLng) {
    List<LatLng> points = [];
    int pointsCount = 64;
    for (int i = 0; i < pointsCount; i++) {
        double angle = (i / pointsCount) * 2 * pi;
        double lat = center.latitude + (radiusLat * cos(angle));
        double lng = center.longitude + (radiusLng * sin(angle));
        points.add(LatLng(lat, lng));
    }
    return points;
  }

  Widget _buildMapLayer() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _stadiumCenter,
        initialZoom: 17.5,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.arenaflow.app',
        ),
        // Custom Chepauk Stadium Overlays
        PolygonLayer(
          polygons: [
            Polygon(
              points: _generateCricketOval(_stadiumCenter, 0.0009, 0.0010),
              color: Theme.of(context).primaryColor.withOpacity(0.05),
              borderStrokeWidth: 2,
              borderColor: Theme.of(context).primaryColor.withOpacity(0.5),
            ),
            Polygon( // Inner Pitch Square
              points: const [
                LatLng(13.0629, 80.2792),
                LatLng(13.0629, 80.2794),
                LatLng(13.0627, 80.2794),
                LatLng(13.0627, 80.2792),
              ],
              color: Theme.of(context).primaryColor.withOpacity(0.3), 
            ),
          ],
        ),
        
        // Active Routing Layer
        if (_isRoutingToExit)
          PolylineLayer(
            polylines: [
              Polyline(
                points: const [
                  LatLng(13.0635, 80.2800), // User in C Stand
                  LatLng(13.0638, 80.2803),
                  LatLng(13.0645, 80.2805), // Wallajah Road Exit
                ],
                strokeWidth: 6.0,
                color: Theme.of(context).colorScheme.secondary, // Glowing Rose path
              ),
            ],
          ),

        MarkerLayer(
          markers: [
            Marker(
              point: const LatLng(13.0635, 80.2800), // User position (C Stand)
              width: 40,
              height: 40,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.5), blurRadius: 10)
                  ],
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 20),
              ),
            ),
            if (!_isRoutingToExit) ...[
              Marker(
                point: const LatLng(13.0615, 80.2785),
                width: 80,
                height: 80,
                child: _buildMarker(Icons.wc, 'Restroom Pavillion'),
              ),
              Marker(
                point: const LatLng(13.0620, 80.2808),
                width: 80,
                height: 80,
                child: _buildMarker(Icons.local_dining, 'Food Court'),
              ),
            ]
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isRoutingToExit ? 'Emergency Routing' : 'Chepauk ArenaMap', style: const TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        actions: [
          if (!_isRoutingToExit)
            Semantics(
              label: 'Filter map layers by amenity type',
              button: true,
              child: IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () {},
              ),
            )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Semantics(
          label: 'Interactive Stadium Map of Chepauk.',
          child: Stack(
            children: [
              Positioned.fill(child: _buildMapLayer()),

              // Floating Live Match Score Overlay
              if (!_isRoutingToExit)
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 5))
                          ]
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: Colors.yellow.shade700, shape: BoxShape.circle),
                              child: const Text('CSK', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('184 / 3 (18.2 ov)', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                                  Text('Target: 201 • Need 17 in 10 balls', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              // Turn-by-Turn Instruction Overlay
              if (_isRoutingToExit)
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Theme.of(context).colorScheme.secondary.withOpacity(0.5)),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 5))
                      ]
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.turn_right, color: Theme.of(context).colorScheme.secondary, size: 36),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Proceed to C Stand Stairs', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                              Text('Wallajah Road Exit is 100m ahead.', style: TextStyle(color: Colors.white70)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Bottom Dock
              Positioned(
                bottom: 24,
                left: 16,
                right: 16,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_isRoutingToExit)
                      ElevatedButton(
                        onPressed: () {
                          setState(() => _isRoutingToExit = false);
                          _mapController.move(_stadiumCenter, 17.5);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Cancel Navigation'),
                      )
                    else
                      Semantics(
                        button: true,
                        label: 'Emergency / Quick Find Nearest Amenity or Exit',
                        child: ElevatedButton.icon(
                          onPressed: _triggerEmergencyRouting,
                          icon: const Icon(Icons.directions_run_rounded, size: 32),
                          label: const Text('FIND NEAREST EXIT'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                            foregroundColor: Colors.white,
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

  Widget _buildMarker(IconData icon, String label) {
    return Semantics(
      label: 'Point of Interest: $label',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, 5))
              ]
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Text(
              label, 
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 10),
            ),
          )
        ],
      ),
    );
  }
}
