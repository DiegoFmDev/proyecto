import 'package:flutter/material.dart';
import 'package:flutter_projects/styles/app_styles.dart';

class TutorBookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;
  final VoidCallback? onTap; // Agregamos esto por si quieres que sea clickeable

  const TutorBookingCard({
    Key? key,
    required this.booking,
    this.onTap,
  }) : super(key: key);

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'aceptada':
      case 'aceptado':
        return AppColors.lightBlueColor;
      case 'en vivo':
        return Colors.redAccent;
      case 'completada':
        return AppColors.primaryGreen;
      case 'rechazada':
      case 'rechazado':
        return AppColors.redColor;
      case 'pendiente':
      case 'solicitada':
        return AppColors.orangeprimary;
      default:
        return AppColors.mediumGreyColor;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'aceptada':
      case 'aceptado':
        return Icons.check_circle_outline;
      case 'en vivo':
        return Icons.play_circle_fill;
      case 'completada':
        return Icons.verified;
      case 'rechazada':
      case 'rechazado':
        return Icons.cancel;
      case 'pendiente':
      case 'solicitada':
        return Icons.access_time;
      default:
        return Icons.info_outline;
    }
  }

  String _statusText(String status) {
    switch (status.toLowerCase()) {
      case 'aceptada':
      case 'aceptado':
        return 'Aceptada';
      case 'en vivo':
        return 'En Vivo';
      case 'completada':
        return 'Completada';
      case 'rechazada':
      case 'rechazado':
        return 'Rechazada';
      case 'pendiente':
      case 'solicitada':
        return 'Pendiente';
      default:
        return 'Programada';
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final start = DateTime.tryParse(booking['start_time'] ?? '') ?? now;
    final end = DateTime.tryParse(booking['end_time'] ?? '') ?? now;
    final status = (booking['status'] ?? '').toString().trim().toLowerCase();
    final subject = booking['subject_name'] ?? 'Tutoría';
    final student = booking['student_name'] ?? 'Estudiante';
    
    final hourStr = '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')} - ${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
    final dateStr = '${start.day.toString().padLeft(2, '0')}/${start.month.toString().padLeft(2, '0')}/${start.year}';
    
    final Color barColor = _statusColor(status);
    final String statusLabel = _statusText(status);
    final IconData statusIcon = _statusIcon(status);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: Card(
              elevation: 8,
              margin: EdgeInsets.only(bottom: 22),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.darkBlue, AppColors.backgroundColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(
                      color: barColor.withOpacity(0.18),
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Barra de estado
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: barColor,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: barColor.withOpacity(0.13),
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsets.all(16),
                            child: Icon(statusIcon, color: barColor, size: 38),
                          ),
                          SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(subject,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                                SizedBox(height: 6),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: barColor.withOpacity(0.18),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.circle, color: barColor, size: 10),
                                          SizedBox(width: 4),
                                          Text(statusLabel,
                                              style: TextStyle(
                                                  color: barColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13)),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Icon(Icons.person, color: Colors.white70, size: 18),
                                    SizedBox(width: 4),
                                    Text(student,
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today, color: AppColors.lightBlueColor, size: 16),
                                    SizedBox(width: 6),
                                    Text(dateStr, style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500)),
                                    SizedBox(width: 14),
                                    Icon(Icons.access_time, color: AppColors.lightBlueColor, size: 16),
                                    SizedBox(width: 6),
                                    Text(hourStr, style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20, bottom: 16, top: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: onTap ?? () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: barColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            child: Text('Ver detalles', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}