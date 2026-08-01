import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/song.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final _searchController = TextEditingController();
  String selectedGenre = 'Todas';
  static const genres = ['Todas', 'Rock', 'Alabanza', 'Folklore', 'Reggae'];

  List<Song> get _filtered {
    return MockSongs.list.where((s) {
      final matchesQuery =
          s.title.toLowerCase().contains(_searchController.text.toLowerCase());
      final matchesGenre = selectedGenre == 'Todas' || s.genre == selectedGenre;
      return matchesQuery && matchesGenre;
    }).toList();
    // TODO: reemplazar por stream de Firestore
    // /bands/{bandId}/songs con Riverpod StreamProvider.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('BIBLIOTECA',
                          style: TextStyle(
                              color: AppColors.muted, fontSize: 10, letterSpacing: 0.5)),
                      Text('REPERTORIO',
                          style: TextStyle(
                              color: AppColors.text,
                              fontSize: 20,
                              fontWeight: FontWeight.w900)),
                    ],
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                        color: AppColors.lime, shape: BoxShape.circle),
                    child: const Icon(Icons.add, color: AppColors.onLime, size: 18),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(color: AppColors.text, fontSize: 14),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search, size: 18, color: AppColors.muted),
                  hintText: 'Buscar canción o artista',
                ),
              ),
            ),
            SizedBox(
              height: 40,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                scrollDirection: Axis.horizontal,
                itemCount: genres.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final g = genres[i];
                  final active = g == selectedGenre;
                  return GestureDetector(
                    onTap: () => setState(() => selectedGenre = g),
                    child: Chip(
                      label: Text(g),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: active ? AppColors.onLime : AppColors.muted,
                        fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                      ),
                      backgroundColor: active ? AppColors.lime : Colors.transparent,
                      side: BorderSide(
                          color: active ? AppColors.lime : AppColors.border),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                itemCount: _filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final song = _filtered[i];
                  return _SongTile(
                    song: song,
                    onTap: () => context.push('/song', extra: song),
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

class _SongTile extends StatelessWidget {
  final Song song;
  final VoidCallback onTap;

  const _SongTile({required this.song, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.card2,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.music_note, color: AppColors.lime, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(song.title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: AppColors.text,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                    Text('${song.artist} · ${song.bpm} BPM · ${song.key}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.muted, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
