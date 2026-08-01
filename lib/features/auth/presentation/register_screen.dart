import 'package:flutter/material.dart';
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
              const AppTextField(icon: Icons.person_outline, hint: 'Nombre completo'),
              const SizedBox(height: 12),
              const AppTextField(
                icon: Icons.mail_outline,
                hint: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              const AppTextField(
                icon: Icons.lock_outline,
                hint: 'Contraseña',
                obscureText: true,
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
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // TODO: FirebaseAuth.instance.createUserWithEmailAndPassword(...)
                  // luego crear doc en /users/{uid} con name + instrument
                  // y navegar a band_choice_screen.
                },
                child: const Row(
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
            ],
          ),
        ),
      ),
    );
  }
}
