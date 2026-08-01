import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/band_member.dart';

class AdminModerationScreen extends StatelessWidget {
  const AdminModerationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
        title: const Text('Moderación',
            style: TextStyle(color: AppColors.text, fontSize: 14)),
      ),
      body: MockAdmin.reports.isEmpty
          ? const Center(
              child: Text('No hay contenido reportado',
                  style: TextStyle(color: AppColors.muted, fontSize: 12)),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: MockAdmin.reports.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final r = MockAdmin.reports[i];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded,
                              size: 14, color: Color(0xFFF2B705)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(r.description,
                                style: const TextStyle(
                                    color: AppColors.text,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('Por ${r.reportedByName}',
                          style: const TextStyle(
                              color: AppColors.muted, fontSize: 10)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                              ),
                              onPressed: () {
                                // TODO: marcar reporte como resuelto en
                                // /bands/{bandId}/reports/{reportId}
                              },
                              child: const Text('Descartar',
                                  style: TextStyle(fontSize: 10)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFFE24B4A).withOpacity(0.15),
                                foregroundColor: const Color(0xFFE24B4A),
                                padding: const EdgeInsets.symmetric(vertical: 8),
                              ),
                              onPressed: () {
                                // TODO: eliminar el mensaje/comentario
                                // original vía Cloud Function
                              },
                              child: const Text('Eliminar contenido',
                                  style: TextStyle(fontSize: 10)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
