import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/song.dart';

class SongDetailScreen extends StatefulWidget {
  final Song song;

  const SongDetailScreen({super.key, required this.song});

  @override
  State<SongDetailScreen> createState() => _SongDetailScreenState();
}

class _SongDetailScreenState extends State<SongDetailScreen> {
  int tabIndex = 0;
  static const tabs = ['Letra', 'Tabs', 'Adjuntos'];

  @override
  Widget build(BuildContext context) {
    final song = widget.song;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.chevron_left, color: AppColors.text),
                  ),
                  Text(
                    'ADMIN: ${song.updatedByName.toUpperCase()} · HACE 2H',
                    style: const TextStyle(color: AppColors.muted, fontSize: 10),
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: abrir panel de comentarios de la canción
                    },
                    icon: const Icon(Icons.chat_bubble_outline,
                        color: AppColors.muted, size: 18),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title.toUpperCase(),
                    style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 22,
                        fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 2),
                  Text(song.artist,
                      style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _MetaPill(icon: Icons.access_time, label: '${song.bpm} BPM'),
                      const SizedBox(width: 8),
                      _MetaPill(icon: Icons.music_note, label: song.key),
                      const SizedBox(width: 8),
                      _MetaPill(icon: Icons.grid_view, label: song.timeSignature),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  for (int i = 0; i < tabs.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: GestureDetector(
                        onTap: () => setState(() => tabIndex = i),
                        child: Column(
                          children: [
                            Text(
                              tabs[i],
                              style: TextStyle(
                                fontSize: 12,
                                color: tabIndex == i ? AppColors.lime : AppColors.muted,
                                fontWeight:
                                    tabIndex == i ? FontWeight.w600 : FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              height: 2,
                              width: 24,
                              color: tabIndex == i
                                  ? AppColors.lime
                                  : Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                    ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => context.push('/song-history'),
                    child: const Row(
                      children: [
                        Icon(Icons.history, size: 14, color: AppColors.muted),
                        SizedBox(width: 4),
                        Text('Historial',
                            style: TextStyle(fontSize: 12, color: AppColors.muted)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Color(0xFF1C1C22), height: 20),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: _ChordLyrics(text: song.lyricsWithChords),
                    ),
                    if (song.youtubeUrl != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.smart_display,
                                color: Colors.redAccent, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                song.youtubeUrl!,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: AppColors.muted, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: ElevatedButton.icon(
                onPressed: () => context.push(
                  '/metronome',
                  extra: {'songTitle': song.title, 'bpm': song.bpm},
                ),
                icon: const Icon(Icons.play_arrow, size: 18),
                label: const Text('ENSAYAR ESTA CANCIÓN'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: AppColors.muted),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 10)),
        ],
      ),
    );
  }
}

/// Renderiza letra con acordes inline tipo "[Bb]texto" resaltando el
/// acorde en lima, monoespaciado para que el alineado se mantenga.
class _ChordLyrics extends StatelessWidget {
  final String text;

  const _ChordLyrics({required this.text});

  @override
  Widget build(BuildContext context) {
    final chordRegex = RegExp(r'\[([^\]]+)\]');
    final spans = <TextSpan>[];
    int lastEnd = 0;
    for (final match in chordRegex.allMatches(text)) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: text.substring(lastEnd, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(color: AppColors.lime, fontWeight: FontWeight.w700),
      ));
      lastEnd = match.end;
    }
    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd)));
    }
    return RichText(
      text: TextSpan(
        style: const TextStyle(
            color: AppColors.text, fontSize: 13, fontFamily: 'monospace', height: 1.6),
        children: spans,
      ),
    );
  }
}
