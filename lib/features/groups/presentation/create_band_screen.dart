import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
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
  final _nameController = TextEditingController();
  bool _loading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String _generateInviteCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // sin O/0/I/1 para evitar confusión
    final rand = Random();
    return List.generate(6, (_) => chars[rand.nextInt(chars.length)]).join();
  }

  Future<void> _createBand() async {
    if (_nameController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Ponele un nombre a la banda');
      return;
    }
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final bandRef = FirebaseFirestore.instance.collection('bands').doc();

      await bandRef.set({
        'name': _nameController.text.trim(),
        'genre': selectedGenre,
        'ownerId': uid,
        'inviteCode': _generateInviteCode(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      // El creador queda como Administrador de la banda
      await bandRef.collection('members').doc(uid).set({
        'role': 'admin',
        'joinedAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      context.go('/home');
    } catch (e) {
      setState(() => _errorMessage = 'No se pudo crear la banda. Probá de nuevo.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

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
              AppTextField(
                icon: Icons.groups_outlined,
                hint: 'Nombre de la banda',
                controller: _nameController,
              ),
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
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Color(0xFFE24B4A), fontSize: 12),
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loading ? null : _createBand,
                child: _loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppColors.onLime),
                      )
                    : const Text('CREAR BANDA'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
