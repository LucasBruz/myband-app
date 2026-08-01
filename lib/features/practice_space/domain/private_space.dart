/// Todo lo de este archivo vive bajo /users/{userId}/privateSpace/... en
/// Firestore — nunca bajo /bands/, así ningún admin de banda puede leerlo.
/// Las Security Rules deben exigir request.auth.uid == userId.

enum FavoriteLinkType { youtube, spotify, pdf, audio, photo }

class FavoriteLink {
  final String id;
  final String title;
  final String subtitle;
  final FavoriteLinkType type;
  final String? url;

  const FavoriteLink({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    this.url,
  });
}

class PracticeNote {
  final String id;
  final String text;
  final DateTime createdAt;

  const PracticeNote({
    required this.id,
    required this.text,
    required this.createdAt,
  });
}

class PracticeGoal {
  final String id;
  final String title;
  final double progress; // 0.0 - 1.0
  final DateTime targetDate;

  const PracticeGoal({
    required this.id,
    required this.title,
    required this.progress,
    required this.targetDate,
  });
}

class MockPrivateSpace {
  static final favorites = [
    const FavoriteLink(
      id: 'f1',
      title: 'Bohemian Rhapsody',
      subtitle: 'Video de referencia',
      type: FavoriteLinkType.youtube,
      url: 'https://youtube.com/watch?v=fJ9rUzIMcZQ',
    ),
    const FavoriteLink(
      id: 'f2',
      title: 'No Woman No Cry',
      subtitle: 'Versión original',
      type: FavoriteLinkType.spotify,
    ),
    const FavoriteLink(
      id: 'f3',
      title: 'Tab acústica - Volver a los 17',
      subtitle: 'PDF personal',
      type: FavoriteLinkType.pdf,
    ),
  ];

  static final notes = [
    PracticeNote(
      id: 'n1',
      text: "Probar afinación Drop D para el estribillo de Livin' on a Prayer",
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    PracticeNote(
      id: 'n2',
      text: 'Practicar la transición Sol - Re más rápido, me trabo ahí',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  static final goals = [
    PracticeGoal(
      id: 'g1',
      title: 'Dominar el solo de Bohemian Rhapsody',
      progress: 0.65,
      targetDate: DateTime(2026, 8, 15),
    ),
  ];
}
