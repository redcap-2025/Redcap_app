class BookingModel {
  final String id;
  final String userId;
  final String truckId;
  final String truckType;
  final String pickupLocation;
  final String dropoffLocation;
  final double pickupLatitude;
  final double pickupLongitude;
  final double dropLatitude;
  final double dropLongitude;
  final double distance;
  final double fare;
  final String goodsType;
  final double weight;
  final String status;
  final String? driverId;
  final String? driverName;
  final String? driverPhone;
  final String? paymentId;
  final String? paymentStatus;
  final String? paymentMethod;
  final DateTime pickupTime;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? notes;
  final double? currentLatitude;
  final double? currentLongitude;

  BookingModel({
    required this.id,
    required this.userId,
    required this.truckId,
    required this.truckType,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.dropLatitude,
    required this.dropLongitude,
    required this.distance,
    required this.fare,
    required this.goodsType,
    required this.weight,
    required this.status,
    this.driverId,
    this.driverName,
    this.driverPhone,
    this.paymentId,
    this.paymentStatus,
    this.paymentMethod,
    required this.pickupTime,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
    this.currentLatitude,
    this.currentLongitude,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      truckId: json['truck_id'] ?? '',
      truckType: json['truck_type'] ?? '',
      pickupLocation: json['pickup_location'] ?? '',
      dropoffLocation: json['drop_location'] ?? '',
      pickupLatitude: (json['pickup_latitude'] ?? 0.0).toDouble(),
      pickupLongitude: (json['pickup_longitude'] ?? 0.0).toDouble(),
      dropLatitude: (json['drop_latitude'] ?? 0.0).toDouble(),
      dropLongitude: (json['drop_longitude'] ?? 0.0).toDouble(),
      distance: (json['distance'] ?? 0.0).toDouble(),
      fare: (json['fare'] ?? 0.0).toDouble(),
      goodsType: json['goods_type'] ?? '',
      weight: (json['weight'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'pending',
      driverId: json['driver_id'],
      driverName: json['driver_name'],
      driverPhone: json['driver_phone'],
      paymentId: json['payment_id'],
      paymentStatus: json['payment_status'],
      paymentMethod: json['payment_method'],
      pickupTime: DateTime.parse(
        json['pickup_time'] ?? DateTime.now().toIso8601String(),
      ),
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
      notes: json['notes'],
      currentLatitude: json['current_latitude']?.toDouble(),
      currentLongitude: json['current_longitude']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'truck_id': truckId,
      'truck_type': truckType,
      'pickup_location': pickupLocation,
      'drop_location': dropoffLocation,
      'pickup_latitude': pickupLatitude,
      'pickup_longitude': pickupLongitude,
      'drop_latitude': dropLatitude,
      'drop_longitude': dropLongitude,
      'distance': distance,
      'fare': fare,
      'goods_type': goodsType,
      'weight': weight,
      'status': status,
      'driver_id': driverId,
      'driver_name': driverName,
      'driver_phone': driverPhone,
      'payment_id': paymentId,
      'payment_status': paymentStatus,
      'payment_method': paymentMethod,
      'pickup_time': pickupTime.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'notes': notes,
      'current_latitude': currentLatitude,
      'current_longitude': currentLongitude,
    };
  }

  BookingModel copyWith({
    String? id,
    String? userId,
    String? truckId,
    String? truckType,
    String? pickupLocation,
    String? dropoffLocation,
    double? pickupLatitude,
    double? pickupLongitude,
    double? dropLatitude,
    double? dropLongitude,
    double? distance,
    double? fare,
    String? goodsType,
    double? weight,
    String? status,
    String? driverId,
    String? driverName,
    String? driverPhone,
    String? paymentId,
    String? paymentStatus,
    String? paymentMethod,
    DateTime? pickupTime,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? notes,
    double? currentLatitude,
    double? currentLongitude,
  }) {
    return BookingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      truckId: truckId ?? this.truckId,
      truckType: truckType ?? this.truckType,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropoffLocation: dropoffLocation ?? this.dropoffLocation,
      pickupLatitude: pickupLatitude ?? this.pickupLatitude,
      pickupLongitude: pickupLongitude ?? this.pickupLongitude,
      dropLatitude: dropLatitude ?? this.dropLatitude,
      dropLongitude: dropLongitude ?? this.dropLongitude,
      distance: distance ?? this.distance,
      fare: fare ?? this.fare,
      goodsType: goodsType ?? this.goodsType,
      weight: weight ?? this.weight,
      status: status ?? this.status,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      paymentId: paymentId ?? this.paymentId,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      pickupTime: pickupTime ?? this.pickupTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notes: notes ?? this.notes,
      currentLatitude: currentLatitude ?? this.currentLatitude,
      currentLongitude: currentLongitude ?? this.currentLongitude,
    );
  }

  bool get isPending => status == 'pending';
  bool get isConfirmed => status == 'confirmed';
  bool get isInProgress => status == 'in_progress';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
  bool get isPaid => paymentStatus == 'paid';
  bool get hasDriver => driverId != null && driverName != null;
  bool get hasLocation => currentLatitude != null && currentLongitude != null;

  String get statusText {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  String get paymentStatusText {
    switch (paymentStatus) {
      case 'pending':
        return 'Pending';
      case 'paid':
        return 'Paid';
      case 'failed':
        return 'Failed';
      case 'refunded':
        return 'Refunded';
      default:
        return 'Unknown';
    }
  }

  @override
  String toString() {
    return 'BookingModel(id: $id, status: $status, fare: $fare, pickupLocation: $pickupLocation)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BookingModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
