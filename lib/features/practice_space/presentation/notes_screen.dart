import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/private_space.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
        title: const Text('Notas y objetivos',
            style: TextStyle(color: AppColors.text, fontSize: 14)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 8),
          const Text('OBJETIVO DE PRÁCTICA',
              style: TextStyle(
                  color: AppColors.muted, fontSize: 11, letterSpacing: 0.5)),
          const SizedBox(height: 8),
          ...MockPrivateSpace.goals.map((g) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.gps_fixed,
                            size: 14, color: AppColors.lime),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(g.title,
                              style: const TextStyle(
                                  color: AppColors.text,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: g.progress,
                        minHeight: 6,
                        backgroundColor: AppColors.card2,
                        valueColor:
                            const AlwaysStoppedAnimation(AppColors.lime),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${(g.progress * 100).round()}% · Meta: ${DateFormat("d 'de' MMMM", 'es').format(g.targetDate)}',
                      style: const TextStyle(
                          color: AppColors.muted, fontSize: 10),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('MIS NOTAS',
                  style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 11,
                      letterSpacing: 0.5)),
              GestureDetector(
                onTap: () {
                  // TODO: abrir formulario simple y guardar en
                  // /users/{uid}/privateSpace/notes/{noteId}
                },
                child: const Icon(Icons.add, size: 16, color: AppColors.lime),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...MockPrivateSpace.notes.map((n) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(n.text,
                        style: const TextStyle(
                            color: AppColors.text, fontSize: 12)),
                    const SizedBox(height: 4),
                    Text(_relativeDate(n.createdAt),
                        style: const TextStyle(
                            color: AppColors.muted, fontSize: 9)),
                  ],
                ),
              )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  String _relativeDate(DateTime date) {
    final days = DateTime.now().difference(date).inDays;
    if (days == 0) return 'Hoy';
    if (days == 1) return 'Hace 1 día';
    return 'Hace $days días';
  }
}
