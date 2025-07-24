import 'package:flutter/material.dart';
import '../services/network_service.dart';
import '../theme/zapchat_theme.dart';

class EnhancedStatusIndicator extends StatelessWidget {
  final NetworkState networkState;
  final ConnectionType connectionType;
  final double bandwidth;
  final bool isSyncing;
  final int syncInterval;
  final int batchSize;
  final int staleProfiles;

  const EnhancedStatusIndicator({
    super.key,
    required this.networkState,
    required this.connectionType,
    required this.bandwidth,
    required this.isSyncing,
    required this.syncInterval,
    required this.batchSize,
    this.staleProfiles = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ZapchatTheme.spacing12,
        vertical: ZapchatTheme.spacing8,
      ),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(ZapchatTheme.radius16),
        border: Border.all(
          color: _getStatusColor().withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Main status row
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Status dot
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _getStatusColor(),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: ZapchatTheme.spacing8),
              // Network state text
              Text(
                _getNetworkStateText(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: _getStatusColor(),
                ),
              ),
              if (isSyncing) ...[
                const SizedBox(width: ZapchatTheme.spacing8),
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(_getStatusColor()),
                  ),
                ),
              ],
            ],
          ),
          
          // Connection details
          if (networkState != NetworkState.offline) ...[
            const SizedBox(height: ZapchatTheme.spacing4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getConnectionIcon(),
                  size: 12,
                  color: _getStatusColor().withOpacity(0.7),
                ),
                const SizedBox(width: ZapchatTheme.spacing4),
                Text(
                  '${bandwidth.toStringAsFixed(1)} Mbps • ${_getConnectionTypeText()}',
                  style: TextStyle(
                    fontSize: 10,
                    color: _getStatusColor().withOpacity(0.7),
                  ),
                ),
              ],
            ),
            
            // Sync details
            const SizedBox(height: ZapchatTheme.spacing2),
            Text(
              'Sync: ${syncInterval}min • Batch: $batchSize',
              style: TextStyle(
                fontSize: 10,
                color: _getStatusColor().withOpacity(0.7),
              ),
            ),
            
            // Stale profiles warning
            if (staleProfiles > 0) ...[
              const SizedBox(height: ZapchatTheme.spacing2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.orange.withOpacity(0.5)),
                ),
                child: Text(
                  '$staleProfiles stale profiles',
                  style: const TextStyle(
                    fontSize: 9,
                    color: Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (networkState) {
      case NetworkState.offline:
        return Colors.red; // Red for offline
      case NetworkState.lowBandwidth:
        return Colors.orange; // Orange for low bandwidth
      case NetworkState.online:
        return Colors.green; // Green for online
      case NetworkState.highBandwidth:
        return Colors.green; // Green for high bandwidth (could use bright green)
    }
  }

  String _getNetworkStateText() {
    switch (networkState) {
      case NetworkState.offline:
        return 'Offline';
      case NetworkState.lowBandwidth:
        return 'Slow Connection';
      case NetworkState.online:
        return 'Online';
      case NetworkState.highBandwidth:
        return 'High Speed';
    }
  }

  IconData _getConnectionIcon() {
    switch (connectionType) {
      case ConnectionType.wifi:
        return Icons.wifi;
      case ConnectionType.mobile:
        return Icons.cell_tower;
      case ConnectionType.ethernet:
        return Icons.router;
      case ConnectionType.none:
        return Icons.signal_wifi_off;
    }
  }

  String _getConnectionTypeText() {
    switch (connectionType) {
      case ConnectionType.wifi:
        return 'WiFi';
      case ConnectionType.mobile:
        return 'Mobile';
      case ConnectionType.ethernet:
        return 'Ethernet';
      case ConnectionType.none:
        return 'None';
    }
  }
}

class NetworkStatusCard extends StatelessWidget {
  final Map<String, dynamic> syncStatus;

  const NetworkStatusCard({
    super.key,
    required this.syncStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(ZapchatTheme.spacing16),
      child: Padding(
        padding: const EdgeInsets.all(ZapchatTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.network_check,
                  color: ZapchatTheme.primaryPurple,
                ),
                const SizedBox(width: ZapchatTheme.spacing8),
                Text(
                  'Network Status',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: ZapchatTheme.spacing16),
            
            // Network state with color indicator
            _buildStatusRowWithColor(
              'State',
              syncStatus['networkState'] ?? 'Unknown',
              Icons.signal_cellular_alt,
              _getNetworkStateColor(syncStatus['networkState']),
            ),
            
            // Connection type
            _buildStatusRow(
              'Connection',
              syncStatus['connectionType'] ?? 'Unknown',
              Icons.wifi,
            ),
            
            // Bandwidth
            _buildStatusRow(
              'Bandwidth',
              '${syncStatus['bandwidth']?.toStringAsFixed(2) ?? '0.00'} Mbps',
              Icons.speed,
            ),
            
            // Sync interval
            _buildStatusRow(
              'Sync Interval',
              '${syncStatus['syncInterval'] ?? 15} minutes',
              Icons.schedule,
            ),
            
            // Batch size
            _buildStatusRow(
              'Batch Size',
              '${syncStatus['batchSize'] ?? 100} events',
              Icons.data_usage,
            ),
            
            // Stale profiles
            if (syncStatus['staleProfiles'] != null && syncStatus['staleProfiles'] > 0) ...[
              _buildStatusRowWithColor(
                'Stale Profiles',
                '${syncStatus['staleProfiles']} profiles need refresh',
                Icons.person_off,
                Colors.orange,
              ),
            ],
            
            // Connected relays
            if (syncStatus['connectedRelays'] != null) ...[
              const SizedBox(height: ZapchatTheme.spacing8),
              Row(
                children: [
                  Icon(
                    Icons.cloud,
                    size: 16,
                    color: ZapchatTheme.textSecondary,
                  ),
                  const SizedBox(width: ZapchatTheme.spacing8),
                  Expanded(
                    child: Text(
                      'Connected Relays: ${(syncStatus['connectedRelays'] as List).length}',
                      style: TextStyle(
                        fontSize: 12,
                        color: ZapchatTheme.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: ZapchatTheme.spacing8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: ZapchatTheme.textSecondary,
          ),
          const SizedBox(width: ZapchatTheme.spacing8),
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: ZapchatTheme.textSecondary,
            ),
          ),
          const SizedBox(width: ZapchatTheme.spacing4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRowWithColor(String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: ZapchatTheme.spacing8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(width: ZapchatTheme.spacing8),
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: ZapchatTheme.textSecondary,
            ),
          ),
          const SizedBox(width: ZapchatTheme.spacing4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getNetworkStateColor(String? state) {
    switch (state) {
      case 'NetworkState.offline':
        return Colors.red;
      case 'NetworkState.lowBandwidth':
        return Colors.orange;
      case 'NetworkState.online':
      case 'NetworkState.highBandwidth':
        return Colors.green;
      default:
        return ZapchatTheme.textSecondary;
    }
  }
} 