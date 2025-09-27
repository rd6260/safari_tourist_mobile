import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:google_maps_flutter/google_maps_flutter.dart';


class RiskMapScreen extends StatefulWidget {
  const RiskMapScreen({super.key});

  @override
  State<RiskMapScreen> createState() => _RiskMapScreenState();
}

class _RiskMapScreenState extends State<RiskMapScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  bool _showRiskLegend = true;
  bool _showUserLocation = true;
  String _selectedLayer = 'All';
  double _mapZoom = 1.0;

  final List<String> _layerOptions = [
    'All',
    'Crime',
    'Traffic',
    'Weather',
    'Crowd',
  ];

  // Sample polygon geo-fence areas around Hubli with realistic coordinates
  final List<PolygonGeoFence> _polygonGeoFences = [
    PolygonGeoFence(
      id: '1',
      name: 'Old Hubli Market Complex',
      vertices: [
        const LatLng(15.3647, 75.1240),
        const LatLng(15.3657, 75.1250),
        const LatLng(15.3652, 75.1260),
        const LatLng(15.3642, 75.1255),
        const LatLng(15.3637, 75.1245),
      ],
      riskLevel: RiskLevel.medium,
      type: GeoFenceType.crime,
      description: 'Crowded market area with pickpocketing risks',
      activeAlerts: 2,
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 15)),
      safetyTips: [
        'Keep valuables secure',
        'Stay aware of surroundings',
        'Avoid displaying cash openly',
      ],
    ),
    PolygonGeoFence(
      id: '2',
      name: 'Railway Station Traffic Zone',
      vertices: [
        const LatLng(15.3173, 75.1230),
        const LatLng(15.3183, 75.1245),
        const LatLng(15.3178, 75.1255),
        const LatLng(15.3163, 75.1250),
        const LatLng(15.3168, 75.1235),
      ],
      riskLevel: RiskLevel.high,
      type: GeoFenceType.traffic,
      description: 'Heavy traffic congestion during peak hours',
      activeAlerts: 3,
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 5)),
      safetyTips: [
        'Use designated crossings',
        'Be extra cautious during rush hours',
        'Consider alternative routes',
      ],
    ),
    PolygonGeoFence(
      id: '3',
      name: 'Unkal Lake Recreation Area',
      vertices: [
        const LatLng(15.2993, 75.1540),
        const LatLng(15.3003, 75.1560),
        const LatLng(15.2998, 75.1570),
        const LatLng(15.2983, 75.1565),
        const LatLng(15.2988, 75.1545),
      ],
      riskLevel: RiskLevel.low,
      type: GeoFenceType.weather,
      description: 'Safe recreational area with weather monitoring',
      activeAlerts: 0,
      lastUpdated: DateTime.now().subtract(const Duration(hours: 1)),
      safetyTips: [
        'Check weather conditions',
        'Stay hydrated',
        'Follow park guidelines',
      ],
    ),
    PolygonGeoFence(
      id: '4',
      name: 'ISKCON Temple Premises',
      vertices: [
        const LatLng(15.3647, 75.1330),
        const LatLng(15.3652, 75.1345),
        const LatLng(15.3647, 75.1350),
        const LatLng(15.3642, 75.1340),
        const LatLng(15.3645, 75.1335),
      ],
      riskLevel: RiskLevel.low,
      type: GeoFenceType.crowd,
      description: 'Tourist-friendly religious site',
      activeAlerts: 0,
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 30)),
      safetyTips: [
        'Respect religious customs',
        'Follow crowd management',
        'Keep footwear secure',
      ],
    ),
    PolygonGeoFence(
      id: '5',
      name: 'Industrial District',
      vertices: [
        const LatLng(15.3947, 75.1430),
        const LatLng(15.3967, 75.1450),
        const LatLng(15.3957, 75.1470),
        const LatLng(15.3937, 75.1460),
        const LatLng(15.3942, 75.1440),
      ],
      riskLevel: RiskLevel.medium,
      type: GeoFenceType.traffic,
      description: 'Heavy vehicle traffic and industrial activity',
      activeAlerts: 1,
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 20)),
      safetyTips: [
        'Avoid peak industrial hours',
        'Stay on designated pathways',
        'Be aware of heavy vehicles',
      ],
    ),
  ];

  // User's current location
  final LatLng _userLocation = const LatLng(15.3647, 75.1240);

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back, color: Colors.grey[700]),
          ),
        ),
        title: const Text(
          'Risk Map',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () =>
                  setState(() => _showRiskLegend = !_showRiskLegend),
              icon: Icon(
                _showRiskLegend ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map Container - In real implementation, this would be Google Maps or similar
          _buildMapView(),

          // Integration Notice
          _buildIntegrationNotice(),

          // Layer Controls
          _buildLayerControls(),

          // Risk Legend
          if (_showRiskLegend) _buildRiskLegend(),

          // Current Location Info
          _buildCurrentLocationInfo(),

          // Geo-fence List
          _buildGeoFenceList(),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "center",
            mini: true,
            backgroundColor: Colors.blue[600],
            onPressed: () => _centerOnUser(),
            child: const Icon(Icons.my_location, color: Colors.white),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "refresh",
            backgroundColor: Colors.orange[600],
            onPressed: () => _refreshRiskData(),
            child: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // Widget _buildMapView() {
  //   return Container(
  //     width: double.infinity,
  //     height: double.infinity,
  //     child: Stack(
  //       children: [
  //         // Simulated map view with polygons
  //         Container(
  //           decoration: BoxDecoration(
  //             gradient: LinearGradient(
  //               begin: Alignment.topCenter,
  //               end: Alignment.bottomCenter,
  //               colors: [
  //                 Colors.blue[100]!,
  //                 Colors.green[50]!,
  //               ],
  //             ),
  //           ),
  //           child: CustomPaint(
  //             painter: MapWithPolygonsPainter(
  //               geoFences: _getFilteredGeoFences(),
  //               userLocation: _userLocation,
  //               zoom: _mapZoom,
  //               showUser: _showUserLocation,
  //             ),
  //             size: Size.infinite,
  //           ),
  //         ),

  //         // Interactive overlay for polygon selection
  //         ..._buildPolygonOverlays(),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildMapView() {
    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
      },
      initialCameraPosition: CameraPosition(
        target: LatLng(15.3647, 75.1240),
        zoom: 14.0,
      ),
      polygons: _buildGoogleMapPolygons(),
      markers: _buildGoogleMapMarkers(),
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
    );
  }

  Set<Polygon> _buildGoogleMapPolygons() {
  return _getFilteredGeoFences().map((fence) => Polygon(
    polygonId: PolygonId(fence.id),
    points: fence.vertices.map((v) => LatLng(v.latitude, v.longitude)).toList(),
    fillColor: _getRiskColor(fence.riskLevel).withValues(alpha: 0.3),
    strokeColor: _getRiskColor(fence.riskLevel),
    strokeWidth: 2,
    onTap: () => _showAreaDetails(fence),
  )).toSet();
}

  Widget _buildIntegrationNotice() {
    return Positioned(
      top: 80,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue[200]!),
        ),
        child: Row(
          children: [
            Icon(Icons.info, color: Colors.blue[600], size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Real Map Integration: Replace this with Google Maps/Mapbox widget',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPolygonOverlays() {
    return _getFilteredGeoFences().map((fence) {
      return Positioned.fill(
        child: GestureDetector(
          onTapDown: (details) {
            if (_isPointInPolygon(details.localPosition, fence)) {
              _showAreaDetails(fence);
            }
          },
          child: Container(color: Colors.transparent),
        ),
      );
    }).toList();
  }

  bool _isPointInPolygon(Offset point, PolygonGeoFence fence) {
    // Convert screen coordinates to map coordinates (simplified)
    final screenToMap = _convertScreenToMapCoordinates(point);
    return _pointInPolygon(screenToMap, fence.vertices);
  }

  LatLng _convertScreenToMapCoordinates(Offset screenPoint) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height - 200;

    final lat = 15.5 - (screenPoint.dy / screenHeight) * 0.5;
    final lng = 75.0 + (screenPoint.dx / screenWidth) * 0.5;

    return LatLng(lat, lng);
  }

  bool _pointInPolygon(LatLng point, List<LatLng> polygon) {
    // Ray casting algorithm for point-in-polygon test
    bool inside = false;
    int j = polygon.length - 1;

    for (int i = 0; i < polygon.length; i++) {
      if (((polygon[i].latitude > point.latitude) !=
              (polygon[j].latitude > point.latitude)) &&
          (point.longitude <
              (polygon[j].longitude - polygon[i].longitude) *
                      (point.latitude - polygon[i].latitude) /
                      (polygon[j].latitude - polygon[i].latitude) +
                  polygon[i].longitude)) {
        inside = !inside;
      }
      j = i;
    }
    return inside;
  }

  Widget _buildLayerControls() {
    return Positioned(
      top: 130,
      left: 20,
      right: 20,
      child: Container(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _layerOptions.length,
          itemBuilder: (context, index) {
            final layer = _layerOptions[index];
            final isSelected = _selectedLayer == layer;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedLayer = layer;
                });
                HapticFeedback.lightImpact();
              },
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue[600] : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  layer,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[700],
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRiskLegend() {
    return Positioned(
      bottom: 220,
      left: 20,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Risk Levels',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildLegendItem('Low Risk', Colors.green),
            _buildLegendItem('Medium Risk', Colors.orange),
            _buildLegendItem('High Risk', Colors.red),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.person, color: Colors.blue[600], size: 16),
                const SizedBox(width: 4),
                const Text('Your Location', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.3),
              border: Border.all(color: color),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCurrentLocationInfo() {
    return Positioned(
      bottom: 120,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Status',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text('Safe Zone', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeoFenceList() {
    return DraggableScrollableSheet(
      initialChildSize: 0.15,
      minChildSize: 0.1,
      maxChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Text(
                      'Active Geo-fences',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_getFilteredGeoFences().length} areas',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  itemCount: _getFilteredGeoFences().length,
                  itemBuilder: (context, index) {
                    final fence = _getFilteredGeoFences()[index];
                    return _buildGeoFenceListItem(fence);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGeoFenceListItem(PolygonGeoFence fence) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getRiskColor(fence.riskLevel).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getRiskColor(fence.riskLevel).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getGeoFenceIcon(fence.type),
              color: _getRiskColor(fence.riskLevel),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fence.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  fence.description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getRiskColor(fence.riskLevel).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  fence.riskLevel.name.toUpperCase(),
                  style: TextStyle(
                    color: _getRiskColor(fence.riskLevel),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (fence.activeAlerts > 0) ...[
                const SizedBox(height: 4),
                Text(
                  '${fence.activeAlerts} alerts',
                  style: TextStyle(fontSize: 10, color: Colors.orange[600]),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  List<PolygonGeoFence> _getFilteredGeoFences() {
    if (_selectedLayer == 'All') return _polygonGeoFences;

    return _polygonGeoFences.where((fence) {
      switch (_selectedLayer) {
        case 'Crime':
          return fence.type == GeoFenceType.crime;
        case 'Traffic':
          return fence.type == GeoFenceType.traffic;
        case 'Weather':
          return fence.type == GeoFenceType.weather;
        case 'Crowd':
          return fence.type == GeoFenceType.crowd;
        default:
          return true;
      }
    }).toList();
  }

  Color _getRiskColor(RiskLevel level) {
    switch (level) {
      case RiskLevel.low:
        return Colors.green;
      case RiskLevel.medium:
        return Colors.orange;
      case RiskLevel.high:
        return Colors.red;
    }
  }

  IconData _getGeoFenceIcon(GeoFenceType type) {
    switch (type) {
      case GeoFenceType.crime:
        return Icons.security;
      case GeoFenceType.traffic:
        return Icons.traffic;
      case GeoFenceType.weather:
        return Icons.wb_sunny;
      case GeoFenceType.crowd:
        return Icons.people;
    }
  }

  void _showAreaDetails(PolygonGeoFence fence) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: ListView(
            controller: scrollController,
            children: [
              Row(
                children: [
                  Icon(
                    _getGeoFenceIcon(fence.type),
                    color: _getRiskColor(fence.riskLevel),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      fence.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getRiskColor(
                        fence.riskLevel,
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      fence.riskLevel.name.toUpperCase(),
                      style: TextStyle(
                        color: _getRiskColor(fence.riskLevel),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                fence.description,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),

              // Safety Tips Section
              const Text(
                'Safety Tips',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...fence.safetyTips
                  .map(
                    (tip) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green[600],
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              tip,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),

              const SizedBox(height: 20),

              // Statistics
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatColumn(
                    'Active Alerts',
                    '${fence.activeAlerts}',
                    Colors.orange,
                  ),
                  _buildStatColumn(
                    'Risk Level',
                    fence.riskLevel.name,
                    _getRiskColor(fence.riskLevel),
                  ),
                  _buildStatColumn(
                    'Last Updated',
                    _formatTime(fence.lastUpdated),
                    Colors.grey,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _shareGeoFence(fence);
                      },
                      icon: const Icon(Icons.share),
                      label: const Text('Share'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _navigateToArea(fence);
                      },
                      icon: const Icon(Icons.navigation),
                      label: const Text('Navigate'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _centerOnUser() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Centered on your location'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    HapticFeedback.lightImpact();
  }

  void _refreshRiskData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Risk data updated from blockchain'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    HapticFeedback.lightImpact();
  }

  void _navigateToArea(PolygonGeoFence fence) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigating to ${fence.name}'),
        backgroundColor: Colors.blue[600],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _shareGeoFence(PolygonGeoFence fence) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${fence.name} geo-fence data'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

// Custom painter for map with polygons
class MapWithPolygonsPainter extends CustomPainter {
  final List<PolygonGeoFence> geoFences;
  final LatLng userLocation;
  final double zoom;
  final bool showUser;

  MapWithPolygonsPainter({
    required this.geoFences,
    required this.userLocation,
    required this.zoom,
    required this.showUser,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw map grid
    _drawMapGrid(canvas, size);

    // Draw polygon geo-fences
    for (final fence in geoFences) {
      _drawPolygon(canvas, size, fence);
    }

    // Draw user location
    if (showUser) {
      _drawUserLocation(canvas, size);
    }

    // Draw points of interest
    _drawPOIs(canvas, size);
  }

  void _drawMapGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.2)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw grid lines to simulate map
    for (int i = 0; i < size.width; i += 50) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble(), size.height),
        paint,
      );
    }

    for (int i = 0; i < size.height; i += 50) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(size.width, i.toDouble()),
        paint,
      );
    }

    // Draw roads (simplified)
    final roadPaint = Paint()
      ..color = Colors.grey[400]!
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(0, size.height * 0.3),
      Offset(size.width, size.height * 0.3),
      roadPaint,
    );

    canvas.drawLine(
      Offset(size.width * 0.4, 0),
      Offset(size.width * 0.4, size.height),
      roadPaint,
    );
  }

  void _drawPolygon(Canvas canvas, Size size, PolygonGeoFence fence) {
    if (fence.vertices.isEmpty) return;

    final path = Path();
    bool first = true;

    for (final vertex in fence.vertices) {
      final point = _latLngToOffset(vertex, size);
      if (first) {
        path.moveTo(point.dx, point.dy);
        first = false;
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();

    // Fill polygon with semi-transparent color
    final fillPaint = Paint()
      ..color = _getRiskColor(fence.riskLevel).withValues(alpha: 0.2)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);

    // Draw polygon border
    final borderPaint = Paint()
      ..color = _getRiskColor(fence.riskLevel)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, borderPaint);

    // Draw label at polygon center
    final center = _getPolygonCenter(fence.vertices);
    final centerPoint = _latLngToOffset(center, size);

    final textPainter = TextPainter(
      text: TextSpan(
        text: fence.name,
        style: TextStyle(
          color: _getRiskColor(fence.riskLevel),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        centerPoint.dx - textPainter.width / 2,
        centerPoint.dy - textPainter.height / 2,
      ),
    );
  }

  void _drawUserLocation(Canvas canvas, Size size) {
    final point = _latLngToOffset(userLocation, size);

    // Draw pulsing circle
    final outerPaint = Paint()
      ..color = Colors.blue.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(point, 20, outerPaint);

    // Draw inner circle
    final innerPaint = Paint()
      ..color = Colors.blue[600]!
      ..style = PaintingStyle.fill;

    canvas.drawCircle(point, 10, innerPaint);

    // Draw person icon
    final iconPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(point, 6, iconPaint);
  }

  void _drawPOIs(Canvas canvas, Size size) {
    final pois = [
      {'name': 'Hospital', 'lat': 15.3547, 'lng': 75.1340, 'color': Colors.red},
      {'name': 'Police', 'lat': 15.3747, 'lng': 75.1140, 'color': Colors.blue},
      {'name': 'Info', 'lat': 15.3447, 'lng': 75.1440, 'color': Colors.green},
    ];

    for (final poi in pois) {
      final point = _latLngToOffset(
        LatLng(poi['lat'] as double, poi['lng'] as double),
        size,
      );

      final paint = Paint()
        ..color = poi['color'] as Color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(point, 8, paint);

      // White border
      final borderPaint = Paint()
        ..color = Colors.white
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(point, 8, borderPaint);
    }
  }

  Offset _latLngToOffset(LatLng latLng, Size size) {
    // Convert lat/lng to screen coordinates (simplified conversion)
    final x = ((latLng.longitude - 75.0) * 2000 + size.width / 2) * zoom;
    final y = ((15.5 - latLng.latitude) * 2000 + size.height / 2) * zoom;
    return Offset(x, y);
  }

  LatLng _getPolygonCenter(List<LatLng> vertices) {
    double centroidLat = 0;
    double centroidLng = 0;

    for (final vertex in vertices) {
      centroidLat += vertex.latitude;
      centroidLng += vertex.longitude;
    }

    return LatLng(centroidLat / vertices.length, centroidLng / vertices.length);
  }

  Color _getRiskColor(RiskLevel level) {
    switch (level) {
      case RiskLevel.low:
        return Colors.green;
      case RiskLevel.medium:
        return Colors.orange;
      case RiskLevel.high:
        return Colors.red;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Data Models
class PolygonGeoFence {
  final String id;
  final String name;
  final List<LatLng> vertices;
  final RiskLevel riskLevel;
  final GeoFenceType type;
  final String description;
  final int activeAlerts;
  final DateTime lastUpdated;
  final List<String> safetyTips;

  PolygonGeoFence({
    required this.id,
    required this.name,
    required this.vertices,
    required this.riskLevel,
    required this.type,
    required this.description,
    required this.activeAlerts,
    required this.lastUpdated,
    required this.safetyTips,
  });
}

class LatLng {
  final double latitude;
  final double longitude;

  const LatLng(this.latitude, this.longitude);
}

enum RiskLevel { low, medium, high }

enum GeoFenceType { crime, traffic, weather, crowd }

/*
REAL MAP INTEGRATION INSTRUCTIONS:

To integrate with real mapping services, replace the _buildMapView() method with:

1. For Google Maps:
```dart
import 'package:google_maps_flutter/google_maps_flutter.dart';

Widget _buildMapView() {
  return GoogleMap(
    onMapCreated: (GoogleMapController controller) {
      _mapController = controller;
    },
    initialCameraPosition: CameraPosition(
      target: LatLng(15.3647, 75.1240), // Hubli coordinates
      zoom: 14.0,
    ),
    polygons: _buildGoogleMapPolygons(),
    markers: _buildGoogleMapMarkers(),
    myLocationEnabled: true,
    myLocationButtonEnabled: false,
  );
}

Set<Polygon> _buildGoogleMapPolygons() {
  return _getFilteredGeoFences().map((fence) => Polygon(
    polygonId: PolygonId(fence.id),
    points: fence.vertices.map((v) => LatLng(v.latitude, v.longitude)).toList(),
    fillColor: _getRiskColor(fence.riskLevel).withValues(alpha: 0.3),
    strokeColor: _getRiskColor(fence.riskLevel),
    strokeWidth: 2,
    onTap: () => _showAreaDetails(fence),
  )).toSet();
}
```

2. For Mapbox:
```dart
import 'package:mapbox_gl/mapbox_gl.dart';

Widget _buildMapView() {
  return MapboxMap(
    onMapCreated: (MapboxMapController controller) {
      _mapController = controller;
      _addPolygonsToMap();
    },
    initialCameraPosition: CameraPosition(
      target: LatLng(15.3647, 75.1240),
      zoom: 14.0,
    ),
    myLocationEnabled: true,
  );
}
```

3. Dependencies to add in pubspec.yaml:
```yaml
dependencies:
  google_maps_flutter: ^2.5.0  # For Google Maps
  mapbox_gl: ^0.16.0          # For Mapbox
  geolocator: ^9.0.2          # For location services
  permission_handler: ^11.0.1  # For location permissions
```

4. Android permissions (android/app/src/main/AndroidManifest.xml):
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
```

5. iOS permissions (ios/Runner/Info.plist):
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to location for safety monitoring.</string>
```
*/
