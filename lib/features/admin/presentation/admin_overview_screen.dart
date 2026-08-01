import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/band_member.dart';

/// Panel de administración. SOLO debe ser alcanzable si
/// MockAdmin.currentUserRole == BandRole.admin — la validación real
/// tiene que estar TAMBIÉN en Firestore Security Rules / Cloud
/// Functions, nunca solo en el cliente.
class AdminOverviewScreen extends StatelessWidget {
  const AdminOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
        title: const Text('Panel de administración',
            style: TextStyle(color: AppColors.text, fontSize: 14)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.5,
            children: [
              _StatTile(
                  icon: Icons.people_outline,
                  label: 'Miembros',
                  value: '${MockAdmin.members.length}'),
              _StatTile(
                  icon: Icons.library_music_outlined,
                  label: 'Canciones',
                  value: '24'),
              _StatTile(
                  icon: Icons.calendar_today_outlined,
                  label: 'Eventos activos',
                  value: '3'),
              _StatTile(
                icon: Icons.storage_outlined,
                label: 'Almacenamiento',
                value: '${MockAdmin.storageUsedGb} GB',
                sub: 'de ${MockAdmin.storageLimitGb} GB',
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ActionTile(
            icon: Icons.people_outline,
            title: 'Gestionar miembros',
            sub: 'Roles, invitaciones, remover',
            onTap: () => context.push('/admin/members'),
          ),
          const SizedBox(height: 8),
          _ActionTile(
            icon: Icons.shield_outlined,
            title: 'Moderación',
            sub: 'Mensajes reportados, contenido',
            onTap: () => context.push('/admin/moderation'),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Código de invitación',
                        style: TextStyle(
                            color: AppColors.text,
                            fontSize: 12,
                            fontWeight: FontWeight.w500)),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 15, color: AppColors.lime),
                      onPressed: () {
                        // TODO: Clipboard.setData con MockAdmin.inviteCode
                      },
                    ),
                  ],
                ),
                Text(
                  MockAdmin.inviteCode,
                  style: const TextStyle(
                      fontFamily: 'Anton',
                      fontSize: 22,
                      letterSpacing: 6,
                      color: AppColors.lime),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('ZONA DE RIESGO',
              style: TextStyle(color: Color(0xFFE24B4A), fontSize: 10, letterSpacing: 0.5)),
          const SizedBox(height: 8),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0x44E24B4A)),
            ),
            onPressed: () {
              // TODO: confirmación + borrar doc /bands/{bandId} y
              // subcolecciones vía Cloud Function (no se puede hacer
              // en cascada solo desde el cliente).
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete_outline, size: 15, color: Color(0xFFE24B4A)),
                SizedBox(width: 8),
                Text('Eliminar banda',
                    style: TextStyle(color: Color(0xFFE24B4A), fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? sub;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 15, color: AppColors.lime),
          const Spacer(),
          Text(value,
              style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 17,
                  fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 10)),
          if (sub != null)
            Text(sub!, style: const TextStyle(color: AppColors.muted, fontSize: 9)),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String sub;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
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
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.card2,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 16, color: AppColors.lime),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
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
              const Icon(Icons.chevron_right, size: 16, color: AppColors.muted),
            ],
          ),
        ),
      ),
    );
  }
}
