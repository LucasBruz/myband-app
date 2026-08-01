import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/setlist.dart';

class SetlistScreen extends StatefulWidget {
  final String eventTitle;
  const SetlistScreen({super.key, required this.eventTitle});

  @override
  State<SetlistScreen> createState() => _SetlistScreenState();
}

class _SetlistScreenState extends State<SetlistScreen> {
  // TODO: reemplazar por el setlistId real y traerlo de Firestore
  late List<SetlistSong> songs = List.of(MockSetlists.sl1.songs);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
        title: Text('Setlist · ${widget.eventTitle}',
            style: const TextStyle(fontSize: 14, color: AppColors.text)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.lime),
            onPressed: () {
              // TODO: abrir selector de canciones de la biblioteca
              // para agregar a /bands/{bandId}/setlists/{id}.songIds
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${songs.length} canciones',
                    style:
                        const TextStyle(color: AppColors.muted, fontSize: 12)),
                const Text('~18 min',
                    style: TextStyle(color: AppColors.muted, fontSize: 12)),
              ],
            ),
          ),
          Expanded(
            child: ReorderableListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: songs.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex -= 1;
                  final item = songs.removeAt(oldIndex);
                  songs.insert(newIndex, item);
                  // TODO: persistir el nuevo orden en Firestore
                  // (campo `order` en el doc del setlist)
                });
              },
              itemBuilder: (context, i) {
                final s = songs[i];
                return Container(
                  key: ValueKey(s.title),
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.drag_indicator,
                          size: 16, color: AppColors.muted),
                      const SizedBox(width: 8),
                      Container(
                        width: 22,
                        height: 22,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.card2,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text('${i + 1}',
                            style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.lime)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s.title,
                                style: const TextStyle(
                                    color: AppColors.text,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500)),
                            Text(s.artist,
                                style: const TextStyle(
                                    color: AppColors.muted, fontSize: 11)),
                          ],
                        ),
                      ),
                      Text(s.duration,
                          style: const TextStyle(
                              color: AppColors.muted, fontSize: 11)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
