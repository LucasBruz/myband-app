import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../admin/domain/band_member.dart';

/// Hub del espacio privado. Todo lo que cuelga de acá vive bajo
/// /users/{userId}/privateSpace/... — ningún admin de banda lo ve.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                children: const [
                  Text('MI ESPACIO',
                      style: TextStyle(
                          color: AppColors.text,
                          fontSize: 20,
                          fontFamily: 'Anton')),
                  Icon(Icons.settings_outlined,
                      color: AppColors.muted, size: 18),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                        color: AppColors.lime, shape: BoxShape.circle),
                    child: const Center(
                      child: Text('L',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.onLime)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Lucas',
                          style: TextStyle(
                              color: AppColors.text,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                      Text('Guitarrista · Los del Ensayo',
                          style:
                              TextStyle(color: AppColors.muted, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _MenuTile(
                    icon: Icons.favorite_border,
                    label: 'Favoritos y enlaces',
                    sub: '3 canciones guardadas',
                    onTap: () => context.push('/favorites'),
                  ),
                  const SizedBox(height: 8),
                  _MenuTile(
                    icon: Icons.description_outlined,
                    label: 'Notas y objetivos',
                    sub: '2 notas · 1 objetivo activo',
                    onTap: () => context.push('/notes'),
                  ),
                  const SizedBox(height: 8),
                  _MenuTile(
                    icon: Icons.mic_none,
                    label: 'Grabaciones y fotos',
                    sub: '5 archivos privados',
                    onTap: () {
                      // TODO: pantalla de grabaciones/fotos, sube a
                      // Firebase Storage bajo /users/{userId}/private/
                    },
                  ),
                  // Solo visible para el rol Administrador. La validación
                  // real (no solo ocultar el botón) va en Security Rules.
                  if (MockAdmin.currentUserRole == BandRole.admin) ...[
                    const SizedBox(height: 8),
                    _MenuTile(
                      icon: Icons.admin_panel_settings_outlined,
                      label: 'Panel de administración',
                      sub: 'Miembros, roles, moderación',
                      onTap: () => context.push('/admin'),
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: TextButton.icon(
                onPressed: () {
                  // TODO: FirebaseAuth.instance.signOut() + volver a /login
                },
                icon: const Icon(Icons.logout, size: 14, color: Color(0xFFE24B4A)),
                label: const Text('Cerrar sesión',
                    style: TextStyle(color: Color(0xFFE24B4A), fontSize: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.label,
    required this.sub,
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
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.card2,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 17, color: AppColors.lime),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: const TextStyle(
                            color: AppColors.text,
                            fontSize: 13,
                            fontWeight: FontWeight.w500)),
                    Text(sub,
                        style: const TextStyle(
                            color: AppColors.muted, fontSize: 10)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right,
                  size: 16, color: AppColors.muted),
            ],
          ),
        ),
      ),
    );
  }
}
