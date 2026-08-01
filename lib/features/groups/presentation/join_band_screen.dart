import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_widgets.dart';

class JoinBandScreen extends StatelessWidget {
  const JoinBandScreen({super.key});

  static const _codeLength = 6;

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
              const ScreenHeadline('Código de', highlight: 'invitación'),
              const SizedBox(height: 8),
              const Text(
                'Pedíselo al administrador de tu banda',
                style: TextStyle(color: AppColors.muted, fontSize: 13),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_codeLength, (i) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 40,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text('',
                          style: TextStyle(color: AppColors.text, fontSize: 16)),
                    ),
                  );
                  // TODO: reemplazar por un PinCodeTextField o 6 TextFields
                  // enfocados en cadena, y validar contra
                  // /bands/{bandId} con inviteCode == código ingresado.
                }),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // TODO: validar código, agregar membresía "musician" en
                  // /bands/{bandId}/members/{uid}, navegar a home_screen.
                },
                child: const Text('UNIRME'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
