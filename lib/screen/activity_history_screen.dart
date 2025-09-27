import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ActivityHistoryScreen extends StatefulWidget {
  const ActivityHistoryScreen({super.key});

  @override
  State<ActivityHistoryScreen> createState() => _ActivityHistoryScreenState();
}

class _ActivityHistoryScreenState extends State<ActivityHistoryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All';

  final List<String> _filterOptions = [
    'All',
    'Alerts',
    'Travel',
    'Check-ins',
    'Anomalies',
  ];

  // Sample activity data
  final List<ActivityItem> _activities = [
    ActivityItem(
      id: '1',
      type: ActivityType.alert,
      title: 'Emergency Alert Sent',
      description:
          'Alert sent to 3 emergency contacts from Chandramouleshwar Temple',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      location: 'Chandramouleshwar Temple, Hubli',
      status: ActivityStatus.resolved,
      details: {
        'contacts_notified': '3',
        'response_time': '2 minutes',
        'authorities_alerted': 'Yes',
      },
      severity: Severity.high,
    ),
    ActivityItem(
      id: '2',
      type: ActivityType.checkin,
      title: 'Safe Check-in',
      description: 'Automatic check-in at hotel location',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      location: 'Hotel Grand Plaza, Hubli',
      status: ActivityStatus.completed,
      details: {'check_in_type': 'Automatic', 'geo_fence': 'Active'},
      severity: Severity.low,
    ),
    ActivityItem(
      id: '3',
      type: ActivityType.travel,
      title: 'Route Completed',
      description: 'Journey from Railway Station to Hotel completed safely',
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      location: 'Hubli Railway Station → Hotel Grand Plaza',
      status: ActivityStatus.completed,
      details: {
        'distance': '12.5 km',
        'duration': '25 minutes',
        'transport_mode': 'Taxi',
        'safety_score': '95%',
      },
      severity: Severity.low,
    ),
    ActivityItem(
      id: '4',
      type: ActivityType.anomaly,
      title: 'Route Deviation Detected',
      description: 'AI detected deviation from planned itinerary',
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      location: 'Old Hubli Market Area',
      status: ActivityStatus.acknowledged,
      details: {
        'deviation_distance': '2.3 km',
        'risk_assessment': 'Medium',
        'user_response': 'Acknowledged',
      },
      severity: Severity.medium,
    ),
    ActivityItem(
      id: '5',
      type: ActivityType.alert,
      title: 'Geo-fence Alert',
      description: 'Entered medium-risk zone - precautionary alert sent',
      timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      location: 'Old Market Area, Hubli',
      status: ActivityStatus.resolved,
      details: {
        'risk_level': 'Medium',
        'zone_type': 'Crowded Market',
        'safety_tips_sent': 'Yes',
      },
      severity: Severity.medium,
    ),
    ActivityItem(
      id: '6',
      type: ActivityType.checkin,
      title: 'Manual Check-in',
      description: 'User manually checked in at attraction',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      location: 'Siddharoodha Math, Hubli',
      status: ActivityStatus.completed,
      details: {'check_in_type': 'Manual', 'visit_duration': '45 minutes'},
      severity: Severity.low,
    ),
    ActivityItem(
      id: '7',
      type: ActivityType.travel,
      title: 'Safe Arrival',
      description: 'Arrived safely at Hubli - Digital ID activated',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
      location: 'Hubli Railway Station',
      status: ActivityStatus.completed,
      details: {
        'arrival_time': '09:15 AM',
        'digital_id_status': 'Activated',
        'local_contacts': 'Updated',
      },
      severity: Severity.low,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
          'Activity History',
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
              onPressed: () => _showExportDialog(),
              icon: Icon(Icons.download, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Statistics Overview
          _buildStatisticsOverview(),

          // Filter Tabs
          _buildFilterTabs(),

          // Activity List
          Expanded(child: _buildActivityList()),
        ],
      ),
    );
  }

  Widget _buildStatisticsOverview() {
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
          const Text(
            'Last 7 Days Activity',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Total Events', '7', Icons.event),
              _buildStatItem('Alerts Sent', '2', Icons.warning),
              _buildStatItem('Safe Check-ins', '3', Icons.check_circle),
              _buildStatItem('Places Visited', '5', Icons.place),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 8),
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
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filterOptions.length,
        itemBuilder: (context, index) {
          final filter = _filterOptions[index];
          final isSelected = _selectedFilter == filter;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = filter;
              });
              HapticFeedback.lightImpact();
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue[600] : Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[700],
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActivityList() {
    final filteredActivities = _getFilteredActivities();

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: filteredActivities.length,
      itemBuilder: (context, index) {
        final activity = filteredActivities[index];
        return _buildActivityCard(activity);
      },
    );
  }

  Widget _buildActivityCard(ActivityItem activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: _getSeverityBorder(activity.severity),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getActivityColor(activity.type).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getActivityIcon(activity.type),
            color: _getActivityColor(activity.type),
            size: 20,
          ),
        ),
        title: Text(
          activity.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              activity.description,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  _formatTimestamp(activity.timestamp),
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
                const SizedBox(width: 16),
                Icon(Icons.location_on, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    activity.location,
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatusBadge(activity.status),
            const SizedBox(height: 4),
            _buildSeverityIndicator(activity.severity),
          ],
        ),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Details',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...activity.details.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 120,
                          child: Text(
                            '${entry.key.replaceAll('_', ' ')}:',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => _shareActivity(activity),
                      icon: const Icon(Icons.share, size: 16),
                      label: const Text('Share'),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () => _viewOnMap(activity),
                      icon: const Icon(Icons.map, size: 16),
                      label: const Text('View on Map'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(ActivityStatus status) {
    MaterialColor color;
    String text;

    switch (status) {
      case ActivityStatus.completed:
        color = Colors.green;
        text = 'Completed';
        break;
      case ActivityStatus.resolved:
        color = Colors.blue;
        text = 'Resolved';
        break;
      case ActivityStatus.acknowledged:
        color = Colors.orange;
        text = 'Acknowledged';
        break;
      case ActivityStatus.pending:
        color = Colors.red;
        text = 'Pending';
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
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSeverityIndicator(Severity severity) {
    Color color;

    switch (severity) {
      case Severity.low:
        color = Colors.green;
        break;
      case Severity.medium:
        color = Colors.orange;
        break;
      case Severity.high:
        color = Colors.red;
        break;
    }

    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Border? _getSeverityBorder(Severity severity) {
    switch (severity) {
      case Severity.high:
        return Border.all(color: Colors.red[300]!, width: 2);
      case Severity.medium:
        return Border.all(color: Colors.orange[300]!, width: 1);
      case Severity.low:
        return null;
    }
  }

  Color _getActivityColor(ActivityType type) {
    switch (type) {
      case ActivityType.alert:
        return Colors.red;
      case ActivityType.travel:
        return Colors.blue;
      case ActivityType.checkin:
        return Colors.green;
      case ActivityType.anomaly:
        return Colors.orange;
    }
  }

  IconData _getActivityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.alert:
        return Icons.warning;
      case ActivityType.travel:
        return Icons.directions;
      case ActivityType.checkin:
        return Icons.check_circle;
      case ActivityType.anomaly:
        return Icons.analytics;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  List<ActivityItem> _getFilteredActivities() {
    if (_selectedFilter == 'All') return _activities;

    return _activities.where((activity) {
      switch (_selectedFilter) {
        case 'Alerts':
          return activity.type == ActivityType.alert;
        case 'Travel':
          return activity.type == ActivityType.travel;
        case 'Check-ins':
          return activity.type == ActivityType.checkin;
        case 'Anomalies':
          return activity.type == ActivityType.anomaly;
        default:
          return true;
      }
    }).toList();
  }

  void _shareActivity(ActivityItem activity) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing activity: ${activity.title}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _viewOnMap(ActivityItem activity) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing ${activity.location} on map'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Export Activity History'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Export your activity history for:'),
            SizedBox(height: 12),
            Text('• Insurance claims'),
            Text('• Travel documentation'),
            Text('• Personal records'),
            Text('• Safety analysis'),
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
                  content: Text('Export feature coming soon!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }
}

// Data Models
class ActivityItem {
  final String id;
  final ActivityType type;
  final String title;
  final String description;
  final DateTime timestamp;
  final String location;
  final ActivityStatus status;
  final Map<String, String> details;
  final Severity severity;

  ActivityItem({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.location,
    required this.status,
    required this.details,
    required this.severity,
  });
}

enum ActivityType { alert, travel, checkin, anomaly }

enum ActivityStatus { completed, resolved, acknowledged, pending }

enum Severity { low, medium, high }
