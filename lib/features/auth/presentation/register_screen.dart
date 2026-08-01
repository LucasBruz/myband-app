import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const instruments = ['Voz', 'Guitarra', 'Bajo', 'Batería', 'Teclado'];
  String? selectedInstrument;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_nameController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Escribí tu nombre');
      return;
    }
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      final uid = credential.user!.uid;

      // Guarda el perfil del usuario en /users/{uid}
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'instrument': selectedInstrument,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await credential.user!.updateDisplayName(_nameController.text.trim());

      if (!mounted) return;
      context.go('/band-choice');
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = _friendlyError(e.code));
    } catch (e) {
      setState(() => _errorMessage = 'Ocurrió un error. Probá de nuevo.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _friendlyError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Ese email ya tiene una cuenta creada';
      case 'invalid-email':
        return 'Ese email no es válido';
      case 'weak-password':
        return 'La contraseña necesita al menos 6 caracteres';
      default:
        return 'No se pudo crear la cuenta ($code)';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ScreenHeadline('Creá tu', highlight: 'cuenta'),
              const SizedBox(height: 24),
              AppTextField(
                icon: Icons.person_outline,
                hint: 'Nombre completo',
                controller: _nameController,
              ),
              const SizedBox(height: 12),
              AppTextField(
                icon: Icons.mail_outline,
                hint: 'Email',
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
              ),
              const SizedBox(height: 12),
              AppTextField(
                icon: Icons.lock_outline,
                hint: 'Contraseña (mínimo 6 caracteres)',
                obscureText: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 16),
              const Text(
                'Instrumento principal (opcional)',
                style: TextStyle(color: AppColors.muted, fontSize: 11),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: instruments
                    .map((i) => SelectableChip(
                          label: i,
                          selected: selectedInstrument == i,
                          onTap: () => setState(() => selectedInstrument = i),
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
                onPressed: _loading ? null : _register,
                child: _loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppColors.onLime),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('CREAR CUENTA'),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 16),
                        ],
                      ),
              ),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: _loading ? null : () => context.pop(),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(color: AppColors.muted, fontSize: 12),
                      children: [
                        TextSpan(text: '¿Ya tenés cuenta? '),
                        TextSpan(
                          text: 'Iniciar sesión',
                          style: TextStyle(color: AppColors.lime),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
