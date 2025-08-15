class TruckModel {
  final String id;
  final String name;
  final String type;
  final String capacity;
  final double ratePerKm;
  final String description;
  final String image;
  final bool isAvailable;
  final double? currentLatitude;
  final double? currentLongitude;
  final String? driverId;
  final String? driverName;
  final String? driverPhone;
  final DateTime createdAt;
  final DateTime updatedAt;

  TruckModel({
    required this.id,
    required this.name,
    required this.type,
    required this.capacity,
    required this.ratePerKm,
    required this.description,
    required this.image,
    required this.isAvailable,
    this.currentLatitude,
    this.currentLongitude,
    this.driverId,
    this.driverName,
    this.driverPhone,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TruckModel.fromJson(Map<String, dynamic> json) {
    return TruckModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      capacity: json['capacity'] ?? '',
      ratePerKm: (json['rate_per_km'] ?? 0.0).toDouble(),
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      isAvailable: json['is_available'] ?? true,
      currentLatitude: json['current_latitude']?.toDouble(),
      currentLongitude: json['current_longitude']?.toDouble(),
      driverId: json['driver_id'],
      driverName: json['driver_name'],
      driverPhone: json['driver_phone'],
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'capacity': capacity,
      'rate_per_km': ratePerKm,
      'description': description,
      'image': image,
      'is_available': isAvailable,
      'current_latitude': currentLatitude,
      'current_longitude': currentLongitude,
      'driver_id': driverId,
      'driver_name': driverName,
      'driver_phone': driverPhone,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  TruckModel copyWith({
    String? id,
    String? name,
    String? type,
    String? capacity,
    double? ratePerKm,
    String? description,
    String? image,
    bool? isAvailable,
    double? currentLatitude,
    double? currentLongitude,
    String? driverId,
    String? driverName,
    String? driverPhone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TruckModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      capacity: capacity ?? this.capacity,
      ratePerKm: ratePerKm ?? this.ratePerKm,
      description: description ?? this.description,
      image: image ?? this.image,
      isAvailable: isAvailable ?? this.isAvailable,
      currentLatitude: currentLatitude ?? this.currentLatitude,
      currentLongitude: currentLongitude ?? this.currentLongitude,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get hasLocation => currentLatitude != null && currentLongitude != null;
  bool get hasDriver => driverId != null && driverName != null;

  @override
  String toString() {
    return 'TruckModel(id: $id, name: $name, type: $type, capacity: $capacity, ratePerKm: $ratePerKm)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TruckModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
