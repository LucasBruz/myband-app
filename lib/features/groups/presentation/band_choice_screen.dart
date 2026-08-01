import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_widgets.dart';

class BandChoiceScreen extends StatelessWidget {
  const BandChoiceScreen({super.key});

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
              const ScreenHeadline('¿Cómo', highlight: 'arrancamos?'),
              const SizedBox(height: 24),
              _ChoiceCard(
                icon: Icons.add,
                iconColor: AppColors.lime,
                iconBg: AppColors.lime.withOpacity(0.13),
                title: 'Crear una banda',
                subtitle: 'Vas a ser el administrador',
                onTap: () {
                  // TODO: Navigator.pushNamed(context, '/create-band');
                },
              ),
              const SizedBox(height: 12),
              _ChoiceCard(
                icon: Icons.vpn_key_outlined,
                iconColor: AppColors.text,
                iconBg: Colors.white.withOpacity(0.08),
                title: 'Unirme con un código',
                subtitle: 'Tu banda ya te tiene que haber invitado',
                onTap: () {
                  // TODO: Navigator.pushNamed(context, '/join-band');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ChoiceCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            color: AppColors.text,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: const TextStyle(
                            color: AppColors.muted, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
