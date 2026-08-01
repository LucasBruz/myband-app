import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/band_event.dart';

class EventDetailScreen extends StatelessWidget {
  final BandEvent event;
  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final isShow = event.type == EventType.show;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (isShow ? const Color(0xFF6C5CE7) : AppColors.lime)
                      .withOpacity(0.15),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  isShow ? 'SHOW' : 'ENSAYO',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isShow ? const Color(0xFF6C5CE7) : AppColors.lime,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                event.title.toUpperCase(),
                style: const TextStyle(
                    fontFamily: 'Anton', fontSize: 26, color: AppColors.text),
              ),
              const SizedBox(height: 12),
              _InfoRow(
                icon: Icons.calendar_today_outlined,
                text: DateFormat("EEEE d 'de' MMMM", 'es').format(event.date),
              ),
              const SizedBox(height: 6),
              _InfoRow(icon: Icons.access_time, text: event.timeRange),
              const SizedBox(height: 6),
              _InfoRow(icon: Icons.location_on_outlined, text: event.location),
              const SizedBox(height: 20),
              if (event.attendance.isNotEmpty) ...[
                const Text('ASISTENCIA',
                    style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 11,
                        letterSpacing: 0.5)),
                const SizedBox(height: 8),
                ...event.attendance.map((m) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: AppColors.lime,
                            child: Text(m.name[0],
                                style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.onLime)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Text(m.name,
                                  style: const TextStyle(
                                      color: AppColors.text, fontSize: 13))),
                          m.status == AttendanceStatus.confirmed
                              ? const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.check,
                                        size: 13, color: AppColors.lime),
                                    SizedBox(width: 4),
                                    Text('Confirmado',
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: AppColors.lime)),
                                  ],
                                )
                              : const Text('Pendiente',
                                  style: TextStyle(
                                      fontSize: 10, color: AppColors.muted)),
                        ],
                      ),
                    )),
                const SizedBox(height: 8),
              ],
              if (event.setlistId != null)
                Material(
                  color: AppColors.card2,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => context.push('/setlist',
                        extra: {'setlistId': event.setlistId, 'eventTitle': event.title}),
                    child: const Padding(
                      padding: EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Icon(Icons.queue_music, size: 18, color: AppColors.lime),
                          SizedBox(width: 10),
                          Expanded(
                              child: Text('Ver setlist del ensayo',
                                  style: TextStyle(
                                      color: AppColors.text, fontSize: 13))),
                          Icon(Icons.chevron_right,
                              size: 18, color: AppColors.muted),
                        ],
                      ),
                    ),
                  ),
                ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: escribir en /bands/{bandId}/events/{eventId}
                    // el estado de asistencia del usuario actual.
                  },
                  child: const Text('CONFIRMAR ASISTENCIA'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.muted),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
      ],
    );
  }
}
