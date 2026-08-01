/// Corresponde a /bands/{bandId}/members/{userId} en Firestore.
enum BandRole { admin, director, leader, musician }

extension BandRoleLabel on BandRole {
  String get label => switch (this) {
        BandRole.admin => 'Administrador',
        BandRole.director => 'Director musical',
        BandRole.leader => 'Líder',
        BandRole.musician => 'Músico',
      };
}

class BandMember {
  final String userId;
  final String name;
  final BandRole role;

  const BandMember({
    required this.userId,
    required this.name,
    required this.role,
  });
}

class BandReport {
  final String id;
  final String reportedByName;
  final String description;
  final DateTime reportedAt;

  const BandReport({
    required this.id,
    required this.reportedByName,
    required this.description,
    required this.reportedAt,
  });
}

class MockAdmin {
  /// TODO: reemplazar por el rol real del usuario logueado, leído de
  /// /bands/{bandId}/members/{uid}. El panel entero debe quedar oculto
  /// (tanto en la UI como validado de nuevo en Cloud Functions/Security
  /// Rules) si currentUserRole != BandRole.admin.
  static const currentUserRole = BandRole.admin;

  static const inviteCode = '7XK92P';
  static const storageUsedGb = 1.2;
  static const storageLimitGb = 5.0;

  static const members = [
    BandMember(userId: 'u_lucas', name: 'Lucas', role: BandRole.admin),
    BandMember(userId: 'u_ana', name: 'Ana', role: BandRole.director),
    BandMember(userId: 'u_diego', name: 'Diego', role: BandRole.musician),
    BandMember(userId: 'u_mica', name: 'Mica', role: BandRole.musician),
  ];

  static final reports = [
    BandReport(
      id: 'r1',
      reportedByName: 'Diego',
      description: 'Mensaje reportado por spam',
      reportedAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    BandReport(
      id: 'r2',
      reportedByName: 'Mica',
      description: 'Comentario reportado en Bohemian Rhapsody',
      reportedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];
}
