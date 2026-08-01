import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
              const Center(child: AppLogo(size: 48)),
              const SizedBox(height: 20),
              const ScreenHeadline('Hola', highlight: 'de nuevo'),
              const SizedBox(height: 8),
              const Text(
                'Iniciá sesión para ver tu banda',
                style: TextStyle(color: AppColors.muted, fontSize: 13),
              ),
              const SizedBox(height: 24),
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
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: flujo de recuperación de contraseña (Firebase Auth)
                  },
                  child: const Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(color: AppColors.lime, fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  // TODO: FirebaseAuth.instance.signInWithEmailAndPassword(...)
                  // luego navegar a band_choice_screen si no tiene banda,
                  // o directo a home_screen si ya pertenece a una.
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('INGRESAR'),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 16),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  // TODO: Navigator.pushNamed(context, '/register');
                },
                child: const Text('Crear cuenta nueva'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
