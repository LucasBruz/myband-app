import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_widgets.dart';

class CreateBandScreen extends StatefulWidget {
  const CreateBandScreen({super.key});

  @override
  State<CreateBandScreen> createState() => _CreateBandScreenState();
}

class _CreateBandScreenState extends State<CreateBandScreen> {
  static const genres = ['Rock', 'Alabanza', 'Cumbia', 'Folklore', 'Jazz'];
  String? selectedGenre;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ScreenHeadline('Datos de', highlight: 'la banda'),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.border,
                      style: BorderStyle.solid,
                      width: 2,
                    ),
                  ),
                  child: const Center(
                    child: Text('Foto',
                        style: TextStyle(color: AppColors.muted, fontSize: 12)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const AppTextField(icon: Icons.groups_outlined, hint: 'Nombre de la banda'),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: genres
                    .map((g) => SelectableChip(
                          label: g,
                          selected: selectedGenre == g,
                          onTap: () => setState(() => selectedGenre = g),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // TODO: crear doc en /bands/{bandId} con name, genre,
                  // ownerId = uid actual, y membresía admin en
                  // /bands/{bandId}/members/{uid}. Navegar a home_screen.
                },
                child: const Text('CREAR BANDA'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
