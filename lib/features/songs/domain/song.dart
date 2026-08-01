/// Entidad de dominio, sin dependencias de Firestore. El mapeo a/desde
/// Firestore (fromMap/toMap) va en la capa data cuando se conecte.
class Song {
  final String id;
  final String title;
  final String artist;
  final int bpm;
  final String key; // tonalidad, ej. "Si♭ mayor"
  final String timeSignature; // ej. "4/4"
  final String genre;
  final String lyricsWithChords; // letra con acordes inline tipo [Bb]texto
  final String? tabs;
  final String? youtubeUrl;
  final String? spotifyUrl;
  final String? pdfUrl;
  final DateTime updatedAt;
  final String updatedByName;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.bpm,
    required this.key,
    required this.timeSignature,
    required this.genre,
    required this.lyricsWithChords,
    this.tabs,
    this.youtubeUrl,
    this.spotifyUrl,
    this.pdfUrl,
    required this.updatedAt,
    required this.updatedByName,
  });
}

/// Una entrada del historial de versiones de una canción.
class SongVersion {
  final String id;
  final String editedByName;
  final DateTime editedAt;
  final String changeSummary; // texto humano, puede venir de IA (resumir cambios)
  final bool isLatest;

  const SongVersion({
    required this.id,
    required this.editedByName,
    required this.editedAt,
    required this.changeSummary,
    this.isLatest = false,
  });
}

/// Datos mock para desarrollar la UI sin depender todavía de Firestore.
/// Reemplazar por un SongRepository real (Firestore) cuando se conecte.
class MockSongs {
  static final list = [
    Song(
      id: '1',
      title: 'Bohemian Rhapsody',
      artist: 'Queen',
      bpm: 72,
      key: 'Si♭ mayor',
      timeSignature: '4/4',
      genre: 'Rock',
      lyricsWithChords:
          '[Bb]Is this the real life\n[Eb]Is this just fan[F]tasy\n[Gm]Caught in a land[Eb]slide\n[Bb]No escape from re[F]ality',
      youtubeUrl: 'https://youtube.com/watch?v=fJ9rUzIMcZQ',
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      updatedByName: 'Ana',
    ),
    Song(
      id: '2',
      title: "Livin' on a Prayer",
      artist: 'Bon Jovi',
      bpm: 122,
      key: 'Sol mayor',
      timeSignature: '4/4',
      genre: 'Rock',
      lyricsWithChords: '[G]Tommy used to work on the docks...',
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedByName: 'Lucas',
    ),
    Song(
      id: '3',
      title: 'Toda la Tierra',
      artist: 'Marcos Brunet',
      bpm: 68,
      key: 'Mi mayor',
      timeSignature: '4/4',
      genre: 'Alabanza',
      lyricsWithChords: '[E]Toda la tierra cante al Señor...',
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedByName: 'Ana',
    ),
  ];

  static final versions = [
    SongVersion(
      id: 'v4',
      editedByName: 'Ana',
      editedAt: DateTime.now().subtract(const Duration(hours: 2)),
      changeSummary: 'Transportó de Do a Si♭ mayor',
      isLatest: true,
    ),
    SongVersion(
      id: 'v3',
      editedByName: 'Lucas',
      editedAt: DateTime.now().subtract(const Duration(days: 1)),
      changeSummary: 'Agregó tab de guitarra en el bridge',
    ),
    SongVersion(
      id: 'v2',
      editedByName: 'Ana',
      editedAt: DateTime.now().subtract(const Duration(days: 12)),
      changeSummary: 'Corrigió acordes del estribillo',
    ),
    SongVersion(
      id: 'v1',
      editedByName: 'Ana',
      editedAt: DateTime.now().subtract(const Duration(days: 20)),
      changeSummary: 'Versión inicial cargada',
    ),
  ];
}
