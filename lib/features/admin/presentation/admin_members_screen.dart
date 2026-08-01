import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/band_member.dart';

class AdminMembersScreen extends StatefulWidget {
  const AdminMembersScreen({super.key});

  @override
  State<AdminMembersScreen> createState() => _AdminMembersScreenState();
}

class _AdminMembersScreenState extends State<AdminMembersScreen> {
  late List<BandMember> members = List.of(MockAdmin.members);

  static const _roleColor = {
    BandRole.admin: AppColors.lime,
    BandRole.director: Color(0xFF6C5CE7),
    BandRole.leader: Color(0xFFF2B705),
    BandRole.musician: AppColors.muted,
  };

  void _openRoleSheet(BandMember member) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _RoleSheet(
        member: member,
        onRoleSelected: (role) {
          setState(() {
            final i = members.indexWhere((m) => m.userId == member.userId);
            members[i] = BandMember(
                userId: member.userId, name: member.name, role: role);
            // TODO: escribir el nuevo rol en
            // /bands/{bandId}/members/{userId}.role
          });
          Navigator.pop(context);
        },
        onRemove: () {
          setState(() => members.removeWhere((m) => m.userId == member.userId));
          // TODO: borrar /bands/{bandId}/members/{userId}
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
        title: Text('Miembros (${members.length})',
            style: const TextStyle(color: AppColors.text, fontSize: 14)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        itemCount: members.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final m = members[i];
          final color = _roleColor[m.role]!;
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: color,
                  child: Text(
                    m.name[0],
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: m.role == BandRole.musician
                            ? AppColors.text
                            : AppColors.onLime),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m.name,
                          style: const TextStyle(
                              color: AppColors.text,
                              fontSize: 13,
                              fontWeight: FontWeight.w500)),
                      Text(m.role.label,
                          style: TextStyle(color: color, fontSize: 10)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, size: 18, color: AppColors.muted),
                  onPressed: () => _openRoleSheet(m),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RoleSheet extends StatefulWidget {
  final BandMember member;
  final ValueChanged<BandRole> onRoleSelected;
  final VoidCallback onRemove;

  const _RoleSheet({
    required this.member,
    required this.onRoleSelected,
    required this.onRemove,
  });

  @override
  State<_RoleSheet> createState() => _RoleSheetState();
}

class _RoleSheetState extends State<_RoleSheet> {
  late BandRole selected = widget.member.role;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.muted,
                child: Text(widget.member.name[0],
                    style: const TextStyle(color: AppColors.text, fontSize: 12)),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.member.name,
                      style: const TextStyle(
                          color: AppColors.text,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  const Text('Cambiar rol en la banda',
                      style: TextStyle(color: AppColors.muted, fontSize: 10)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...BandRole.values.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: selected == r
                      ? AppColors.lime.withOpacity(0.1)
                      : AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => setState(() => selected = r),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(r.label,
                              style: TextStyle(
                                  color: selected == r
                                      ? AppColors.lime
                                      : AppColors.text,
                                  fontSize: 13)),
                          if (selected == r)
                            const Icon(Icons.check, size: 15, color: AppColors.lime),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => widget.onRoleSelected(selected),
            child: const Text('GUARDAR CAMBIOS'),
          ),
          TextButton(
            onPressed: widget.onRemove,
            child: const Text('Quitar de la banda',
                style: TextStyle(color: Color(0xFFE24B4A), fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
