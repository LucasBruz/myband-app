import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/song.dart';

class SongHistoryScreen extends StatelessWidget {
  final List<SongVersion> versions;

  const SongHistoryScreen({super.key, required this.versions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 20, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.chevron_left, color: AppColors.text),
                  ),
                  const Text('Historial de cambios',
                      style: TextStyle(
                          color: AppColors.text,
                          fontSize: 15,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: versions.length,
                itemBuilder: (_, i) {
                  final v = versions[i];
                  final isLast = i == versions.length - 1;
                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              margin: const EdgeInsets.only(top: 4),
                              decoration: BoxDecoration(
                                color: v.isLatest
                                    ? AppColors.lime
                                    : const Color(0xFF3A3B40),
                                shape: BoxShape.circle,
                              ),
                            ),
                            if (!isLast)
                              Expanded(
                                child: Container(
                                  width: 1,
                                  color: AppColors.border,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.card,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(v.editedByName,
                                          style: const TextStyle(
                                              color: AppColors.text,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600)),
                                      Text(
                                        DateFormat('d MMM, HH:mm')
                                            .format(v.editedAt),
                                        style: const TextStyle(
                                            color: AppColors.muted, fontSize: 10),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  // Resumen de cambios: en producción puede
                                  // generarse con la función de IA
                                  // "resumir cambios" descripta en la doc técnica.
                                  Text(v.changeSummary,
                                      style: const TextStyle(
                                          color: AppColors.muted, fontSize: 12)),
                                  if (v.isLatest) ...[
                                    const SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: () {
                                        // TODO: mostrar diff contra versión anterior
                                      },
                                      child: const Text('Ver diferencias',
                                          style: TextStyle(
                                              color: AppColors.lime, fontSize: 11)),
                                    ),
                                  ] else
                                    GestureDetector(
                                      onTap: () {
                                        // TODO: restaurar esta versión
                                        // (crea una nueva versión que copia
                                        // el snapshot de esta, con
                                        // restoredFrom = v.id)
                                      },
                                      child: const Text('Restaurar esta versión',
                                          style: TextStyle(
                                              color: AppColors.muted, fontSize: 11)),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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
