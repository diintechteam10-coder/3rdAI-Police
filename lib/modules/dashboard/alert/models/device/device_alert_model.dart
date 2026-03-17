enum DeviceAlertType {
  connectivity,
  power,
  hardware,
  storage,
  performance,
  security,
}

enum AlertSeverity { critical, high, medium, low }

enum AlertStatus { active, acknowledged, resolved }

const Map<DeviceAlertType, List<String>> subTypeMap = {
  DeviceAlertType.connectivity: [
    "Camera Offline",
    "NVR Offline",
    "Server Disconnected",
    "Device Not Reachable",
    "Network Timeout",
    "IP Conflict",
    "DNS Failure",
    "SIM Card Disconnected",
    "Weak Signal",
  ],
  DeviceAlertType.power: [
    "Power Failure",
    "Power Restored",
    "Battery Low",
    "Battery Critical",
    "UPS Failure",
    "Generator Failure",
    "Voltage Fluctuation",
    "Overcurrent Detected",
  ],
  DeviceAlertType.hardware: [
    "Camera Tampering",
    "Lens Blocked",
    "Camera Physically Damaged",
    "Overheating",
    "Fan Failure",
    "Sensor Failure",
    "Microphone Failure",
    "Speaker Failure",
    "SD Card Removed",
  ],
  DeviceAlertType.storage: [
    "Storage Full",
    "HDD Error",
    "HDD Corrupted",
    "Recording Failed",
    "Recording Stopped",
    "Backup Failed",
    "Cloud Sync Failed",
    "SD Card Full",
    "SD Card Error",
  ],
  DeviceAlertType.performance: [
    "Low FPS",
    "Stream Interrupted",
    "High CPU Usage",
    "High Memory Usage",
    "Frame Drop Detected",
    "Bitrate Drop",
    "Video Lag",
    "Audio Lag",
  ],
  DeviceAlertType.security: [
    "Unauthorized Login Attempt",
    "Multiple Failed Login Attempts",
    "Admin Password Changed",
    "Firmware Update Required",
    "Firmware Update Failed",
    "Configuration Changed",
    "Device Reset",
    "Factory Reset",
    "Time Sync Error",
    "SSL Certificate Expired",
  ],
};

class DeviceAlert {
  final String id;
  final DeviceAlertType type;
  final String subType;
  final AlertSeverity severity;
  final DateTime createdAt;

  DeviceAlert({
    required this.id,
    required this.type,
    required this.subType,
    required this.severity,
    required this.createdAt,
  });
}