import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/band_event.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat.yMMMM('es').format(DateTime.now()).toUpperCase(),
                        style: const TextStyle(
                            color: AppColors.muted, fontSize: 10),
                      ),
                      const Text('CALENDARIO',
                          style: TextStyle(
                              color: AppColors.text,
                              fontSize: 20,
                              fontFamily: 'Anton')),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO: abrir formulario de nuevo evento y crear doc
                      // en /bands/{bandId}/events
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                          color: AppColors.lime, shape: BoxShape.circle),
                      child: const Icon(Icons.add,
                          color: AppColors.onLime, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: MockEvents.list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final e = MockEvents.list[i];
                  final isShow = e.type == EventType.show;
                  return Material(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => context.push('/event', extra: e),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: isShow
                                    ? const Color(0xFF6C5CE7).withOpacity(0.13)
                                    : AppColors.card2,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    DateFormat('EEE', 'es')
                                        .format(e.date)
                                        .toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 9,
                                        color: isShow
                                            ? const Color(0xFF6C5CE7)
                                            : AppColors.lime),
                                  ),
                                  Text(
                                    DateFormat('d').format(e.date),
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.text),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(e.title,
                                      style: const TextStyle(
                                          color: AppColors.text,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)),
                                  Text(e.timeRange,
                                      style: const TextStyle(
                                          color: AppColors.muted,
                                          fontSize: 12)),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right,
                                color: AppColors.muted, size: 18),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
