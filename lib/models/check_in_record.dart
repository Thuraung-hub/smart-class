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

  /// Convert object to Map (for SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'className': className,
      'timestamp': timestamp.toIso8601String(),
      'lat': lat,
      'lng': lng,
      'reflection': reflection,
      'qrScanned': qrScanned ? 1 : 0,
      'gpsVerified': gpsVerified ? 1 : 0,
    };
  }

  /// Create object from Map (SQLite)
  factory CheckInRecord.fromMap(Map<String, dynamic> map) {
    return CheckInRecord(
      id: map['id'],
      className: map['className'],
      timestamp: DateTime.parse(map['timestamp']),
      lat: map['lat'],
      lng: map['lng'],
      reflection: map['reflection'],
      qrScanned: map['qrScanned'] == 1,
      gpsVerified: map['gpsVerified'] == 1,
    );
  }

  /// Convert to JSON
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

  /// Create from JSON
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

  /// Copy object with changes
  CheckInRecord copyWith({
    String? id,
    String? className,
    DateTime? timestamp,
    double? lat,
    double? lng,
    String? reflection,
    bool? qrScanned,
    bool? gpsVerified,
  }) {
    return CheckInRecord(
      id: id ?? this.id,
      className: className ?? this.className,
      timestamp: timestamp ?? this.timestamp,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      reflection: reflection ?? this.reflection,
      qrScanned: qrScanned ?? this.qrScanned,
      gpsVerified: gpsVerified ?? this.gpsVerified,
    );
  }

  @override
  String toString() {
    return 'CheckInRecord(id: $id, className: $className, timestamp: $timestamp)';
  }
}