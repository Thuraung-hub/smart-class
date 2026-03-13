class CheckInRecord {
  final String id;
  final String className;
  final DateTime timestamp;
  final double? lat;
  final double? lng;
  final String? reflection;
  final bool qrScanned;
  final bool gpsVerified;

  CheckInRecord({
    required this.id,
    required this.className,
    required this.timestamp,
    this.lat,
    this.lng,
    this.reflection,
    this.qrScanned = false,
    this.gpsVerified = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'className': className,
        'timestamp': timestamp.toIso8601String(),
        'lat': lat,
        'lng': lng,
        'reflection': reflection,
        'qrScanned': qrScanned,
        'gpsVerified': gpsVerified,
      };

  factory CheckInRecord.fromJson(Map<String, dynamic> json) => CheckInRecord(
        id: json['id'],
        className: json['className'],
        timestamp: DateTime.parse(json['timestamp']),
        lat: json['lat']?.toDouble(),
        lng: json['lng']?.toDouble(),
        reflection: json['reflection'],
        qrScanned: json['qrScanned'] ?? false,
        gpsVerified: json['gpsVerified'] ?? false,
      );
}
