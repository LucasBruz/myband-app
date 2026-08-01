import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/private_space.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  static const _colors = {
    FavoriteLinkType.youtube: Color(0xFFFF4D4D),
    FavoriteLinkType.spotify: Color(0xFF1DB954),
    FavoriteLinkType.pdf: AppColors.lime,
    FavoriteLinkType.audio: AppColors.lime,
    FavoriteLinkType.photo: AppColors.lime,
  };

  static const _icons = {
    FavoriteLinkType.youtube: Icons.play_circle_outline,
    FavoriteLinkType.spotify: Icons.music_note,
    FavoriteLinkType.pdf: Icons.picture_as_pdf_outlined,
    FavoriteLinkType.audio: Icons.mic_none,
    FavoriteLinkType.photo: Icons.photo_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
        title: const Text('Favoritos y enlaces',
            style: TextStyle(color: AppColors.text, fontSize: 14)),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Solo vos ves esto — no se comparte con la banda',
                style: TextStyle(color: AppColors.muted, fontSize: 10),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                ...MockPrivateSpace.favorites.map((f) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _colors[f.type]!.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(_icons[f.type],
                                size: 17, color: _colors[f.type]),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(f.title,
                                    style: const TextStyle(
                                        color: AppColors.text,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500)),
                                Text(f.subtitle,
                                    style: const TextStyle(
                                        color: AppColors.muted,
                                        fontSize: 10)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                GestureDetector(
                  onTap: () {
                    // TODO: abrir selector (pegar link de YouTube/Spotify
                    // o subir PDF) y guardar en
                    // /users/{uid}/privateSpace/links/{linkId}
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColors.border, style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 15, color: AppColors.muted),
                        SizedBox(width: 8),
                        Text('Agregar enlace o archivo',
                            style: TextStyle(
                                color: AppColors.muted, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
