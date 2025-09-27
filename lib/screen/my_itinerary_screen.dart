import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyItineraryScreen extends StatefulWidget {
  const MyItineraryScreen({super.key});

  @override
  State<MyItineraryScreen> createState() => _MyItineraryScreenState();
}

class _MyItineraryScreenState extends State<MyItineraryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  // Sample itinerary data
  final List<ItineraryDay> _itinerary = [
    ItineraryDay(
      day: 1,
      date: 'Today, Jan 15',
      locations: [
        ItineraryLocation(
          name: 'Hubli Railway Station',
          time: '09:00 AM',
          type: LocationType.transport,
          riskLevel: RiskLevel.low,
          description: 'Arrival point',
          duration: '30 min',
          isCompleted: true,
        ),
        ItineraryLocation(
          name: 'Hotel Grand Plaza',
          time: '10:00 AM',
          type: LocationType.accommodation,
          riskLevel: RiskLevel.low,
          description: 'Check-in and rest',
          duration: '2 hours',
          isCompleted: true,
        ),
        ItineraryLocation(
          name: 'Chandramouleshwar Temple',
          time: '02:00 PM',
          type: LocationType.attraction,
          riskLevel: RiskLevel.low,
          description: 'Ancient temple visit',
          duration: '1.5 hours',
          isCompleted: false,
          isActive: true,
        ),
        ItineraryLocation(
          name: 'Old Hubli Market',
          time: '04:30 PM',
          type: LocationType.shopping,
          riskLevel: RiskLevel.medium,
          description: 'Local shopping experience',
          duration: '2 hours',
          isCompleted: false,
        ),
      ],
    ),
    ItineraryDay(
      day: 2,
      date: 'Tomorrow, Jan 16',
      locations: [
        ItineraryLocation(
          name: 'Nrupatunga Betta',
          time: '07:00 AM',
          type: LocationType.nature,
          riskLevel: RiskLevel.medium,
          description: 'Sunrise trek and photography',
          duration: '4 hours',
          isCompleted: false,
        ),
        ItineraryLocation(
          name: 'Siddharoodha Math',
          time: '12:00 PM',
          type: LocationType.attraction,
          riskLevel: RiskLevel.low,
          description: 'Spiritual center visit',
          duration: '1 hour',
          isCompleted: false,
        ),
        ItineraryLocation(
          name: 'Unkal Lake',
          time: '03:00 PM',
          type: LocationType.nature,
          riskLevel: RiskLevel.low,
          description: 'Boating and relaxation',
          duration: '2.5 hours',
          isCompleted: false,
        ),
      ],
    ),
    ItineraryDay(
      day: 3,
      date: 'Jan 17, 2025',
      locations: [
        ItineraryLocation(
          name: 'Banashankari Temple',
          time: '09:00 AM',
          type: LocationType.attraction,
          riskLevel: RiskLevel.low,
          description: 'Historic temple complex',
          duration: '2 hours',
          isCompleted: false,
        ),
        ItineraryLocation(
          name: 'Hubli Airport',
          time: '05:00 PM',
          type: LocationType.transport,
          riskLevel: RiskLevel.low,
          description: 'Departure',
          duration: '1 hour',
          isCompleted: false,
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _itinerary.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
          'My Itinerary',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
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
              onPressed: () => _showAddLocationDialog(),
              icon: Icon(Icons.add, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Trip Overview Header
          _buildTripOverview(),
          
          // Day Selector Tabs
          _buildDayTabs(),
          
          // Itinerary Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _itinerary
                  .map((day) => _buildDayContent(day))
                  .toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _startNavigation(),
        backgroundColor: Colors.blue[600],
        icon: const Icon(Icons.navigation, color: Colors.white),
        label: const Text(
          'Start Navigation',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildTripOverview() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[400]!, Colors.blue[600]!],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Karnataka Exploration',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Jan 15 - Jan 17, 2025',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '3 DAYS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildOverviewStat('Locations', '8'),
              const SizedBox(width: 24),
              _buildOverviewStat('Completed', '2/8'),
              const SizedBox(width: 24),
              _buildOverviewStat('Risk Level', 'Low'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildDayTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(8),
        ),
        indicatorPadding: const EdgeInsets.all(4),
        labelColor: Colors.blue[700],
        unselectedLabelColor: Colors.grey[600],
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        tabs: _itinerary
            .map((day) => Tab(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Day ${day.day}'),
                      Text(
                        day.date.split(',')[0],
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildDayContent(ItineraryDay day) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Day Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              day.date,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getDayStatusColor(day).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _getDayStatusText(day),
                style: TextStyle(
                  color: _getDayStatusColor(day),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        
        // Locations Timeline
        ...day.locations.asMap().entries.map((entry) {
          final index = entry.key;
          final location = entry.value;
          final isLast = index == day.locations.length - 1;
          
          return _buildLocationItem(location, isLast);
        }),
      ],
    );
  }

  Widget _buildLocationItem(ItineraryLocation location, bool isLast) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: location.isCompleted
                    ? Colors.green[600]
                    : location.isActive
                        ? Colors.blue[600]
                        : Colors.grey[300],
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: location.isCompleted
                  ? const Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    )
                  : location.isActive
                      ? Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        )
                      : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                color: Colors.grey[300],
              ),
          ],
        ),
        const SizedBox(width: 16),
        
        // Location Content
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: location.isActive
                  ? Border.all(color: Colors.blue[300]!, width: 2)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        location.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: location.isActive
                              ? Colors.blue[700]
                              : Colors.grey[800],
                        ),
                      ),
                    ),
                    _buildRiskBadge(location.riskLevel),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      location.time,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.schedule,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      location.duration,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  location.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildLocationTypeChip(location.type),
                    const Spacer(),
                    if (!location.isCompleted && !location.isActive)
                      TextButton.icon(
                        onPressed: () => _startLocationNavigation(location),
                        icon: Icon(
                          Icons.directions,
                          size: 16,
                          color: Colors.blue[600],
                        ),
                        label: Text(
                          'Navigate',
                          style: TextStyle(
                            color: Colors.blue[600],
                            fontSize: 12,
                          ),
                        ),
                      )
                    else if (location.isActive)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Current Location',
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRiskBadge(RiskLevel riskLevel) {
    MaterialColor color;
    String text;
    
    switch (riskLevel) {
      case RiskLevel.low:
        color = Colors.green;
        text = 'Low Risk';
        break;
      case RiskLevel.medium:
        color = Colors.orange;
        text = 'Medium Risk';
        break;
      case RiskLevel.high:
        color = Colors.red;
        text = 'High Risk';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color[700],
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildLocationTypeChip(LocationType type) {
    IconData icon;
    MaterialColor color;
    String label;
    
    switch (type) {
      case LocationType.attraction:
        icon = Icons.place;
        color = Colors.purple;
        label = 'Attraction';
        break;
      case LocationType.accommodation:
        icon = Icons.hotel;
        color = Colors.blue;
        label = 'Hotel';
        break;
      case LocationType.transport:
        icon = Icons.train;
        color = Colors.green;
        label = 'Transport';
        break;
      case LocationType.shopping:
        icon = Icons.shopping_bag;
        color = Colors.orange;
        label = 'Shopping';
        break;
      case LocationType.nature:
        icon = Icons.nature;
        color = Colors.teal;
        label = 'Nature';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color[700]),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color[700],
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDayStatusColor(ItineraryDay day) {
    if (day.locations.every((loc) => loc.isCompleted)) {
      return Colors.green;
    } else if (day.locations.any((loc) => loc.isActive)) {
      return Colors.blue;
    } else {
      return Colors.grey;
    }
  }

  String _getDayStatusText(ItineraryDay day) {
    if (day.locations.every((loc) => loc.isCompleted)) {
      return 'Completed';
    } else if (day.locations.any((loc) => loc.isActive)) {
      return 'In Progress';
    } else {
      return 'Upcoming';
    }
  }

  void _startNavigation() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.navigation, color: Colors.white),
            SizedBox(width: 8),
            Text('Navigation started to next location'),
          ],
        ),
        backgroundColor: Colors.blue[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _startLocationNavigation(ItineraryLocation location) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting navigation to ${location.name}'),
        backgroundColor: Colors.blue[600],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAddLocationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add Location'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Add new locations to your itinerary'),
            SizedBox(height: 16),
            Text(
              'This feature allows you to customize your travel plan with AI-powered safety recommendations.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Add Location feature coming soon!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Add Location'),
          ),
        ],
      ),
    );
  }
}

// Data Models
class ItineraryDay {
  final int day;
  final String date;
  final List<ItineraryLocation> locations;

  ItineraryDay({
    required this.day,
    required this.date,
    required this.locations,
  });
}

class ItineraryLocation {
  final String name;
  final String time;
  final LocationType type;
  final RiskLevel riskLevel;
  final String description;
  final String duration;
  final bool isCompleted;
  final bool isActive;

  ItineraryLocation({
    required this.name,
    required this.time,
    required this.type,
    required this.riskLevel,
    required this.description,
    required this.duration,
    this.isCompleted = false,
    this.isActive = false,
  });
}

enum LocationType {
  attraction,
  accommodation,
  transport,
  shopping,
  nature,
}

enum RiskLevel {
  low,
  medium,
  high,
}