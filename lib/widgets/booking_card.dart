import 'package:flutter/material.dart';
import '../../../../constants/app_constants.dart';

class BookingCard extends StatelessWidget {
  final String bookingId;
  final String pickupLocation;
  final String dropoffLocation;
  final String date;
  final String time;
  final String status;
  final double fare;
  final double distance;
  final String truckType;
  final VoidCallback onTap;

  const BookingCard({
    super.key,
    required this.bookingId,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.date,
    required this.time,
    required this.status,
    required this.fare,
    required this.distance,
    required this.truckType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive scaling based on screen width
    final double screenWidth = MediaQuery.of(context).size.width;
    final double cardPadding = screenWidth * 0.04; // 4% of screen width
    final double fontSizeSmall = screenWidth * 0.032; // ~12-14sp
    final double fontSizeMedium = screenWidth * 0.038; // ~14-16sp
    final double fontSizeLarge = screenWidth * 0.042; // ~16-18sp

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(cardPadding),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Booking ID and Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'Booking ID: #$bookingId',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppConstants.textPrimaryColor,
                              fontSize: fontSizeMedium,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _getStatusText(status),
                            style: TextStyle(
                              fontSize: fontSizeSmall,
                              fontWeight: FontWeight.w600,
                              color: _getStatusColor(status),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: cardPadding * 0.8),
                    // Pickup Location
                    _buildLocationRow(
                      icon: Icons.my_location,
                      label: 'Pickup',
                      location: pickupLocation,
                      color: AppConstants.successColor,
                      fontSize: fontSizeSmall,
                    ),
                    SizedBox(height: cardPadding * 0.6),
                    // Dropoff Location
                    _buildLocationRow(
                      icon: Icons.location_on,
                      label: 'Dropoff',
                      location: dropoffLocation,
                      color: AppConstants.errorColor,
                      fontSize: fontSizeSmall,
                    ),
                    SizedBox(height: cardPadding * 0.8),
                    const Divider(height: 1, color: AppConstants.dividerColor),
                    SizedBox(height: cardPadding * 0.8),
                    // Info Rows
                    _buildInfoRow(
                      label: 'Date & Time',
                      value: '$date, $time',
                      icon: Icons.calendar_today,
                      fontSize: fontSizeSmall,
                    ),
                    SizedBox(height: cardPadding * 0.6),
                    _buildInfoRow(
                      label: 'Distance',
                      value: '${distance.toStringAsFixed(1)} km',
                      icon: Icons.route,
                      fontSize: fontSizeSmall,
                    ),
                    SizedBox(height: cardPadding * 0.6),
                    _buildInfoRow(
                      label: 'Truck Type',
                      value: truckType,
                      icon: Icons.local_shipping,
                      fontSize: fontSizeSmall,
                    ),
                    SizedBox(height: cardPadding * 0.8),
                    const Divider(height: 1, color: AppConstants.dividerColor),
                    SizedBox(height: cardPadding * 0.8),
                    // Total Fare
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Fare',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppConstants.textPrimaryColor,
                            fontSize: fontSizeMedium,
                          ),
                        ),
                        Text(
                          AppConstants.formatCurrency(fare),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppConstants.primaryColor,
                            fontSize: fontSizeLarge,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLocationRow({
    required IconData icon,
    required String label,
    required String location,
    required Color color,
    required double fontSize,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$label:',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppConstants.textSecondaryColor,
                  fontSize: fontSize,
                ),
              ),
              Text(
                location,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppConstants.textPrimaryColor,
                  fontSize: fontSize + 2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    required IconData icon,
    required double fontSize,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppConstants.textSecondaryColor),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppConstants.textPrimaryColor,
            fontSize: fontSize,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: AppConstants.textSecondaryColor,
              fontSize: fontSize,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case AppConstants.statusPending:
        return AppConstants.warningColor;
      case AppConstants.statusConfirmed:
        return AppConstants.accentColor;
      case AppConstants.statusInProgress:
        return AppConstants.primaryColor;
      case AppConstants.statusCompleted:
        return AppConstants.successColor;
      case AppConstants.statusCancelled:
        return AppConstants.errorColor;
      default:
        return AppConstants.textSecondaryColor;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case AppConstants.statusPending:
        return 'Pending';
      case AppConstants.statusConfirmed:
        return 'Confirmed';
      case AppConstants.statusInProgress:
        return 'In Progress';
      case AppConstants.statusCompleted:
        return 'Completed';
      case AppConstants.statusCancelled:
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }
}