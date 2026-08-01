/// Corresponde a /bands/{bandId}/setlists/{setlistId} en Firestore.
class SetlistSong {
  final String title;
  final String artist;
  final String duration; // formateado, ej. "5:55"

  const SetlistSong({
    required this.title,
    required this.artist,
    required this.duration,
  });
}

class Setlist {
  final String id;
  final String name;
  final List<SetlistSong> songs;

  const Setlist({required this.id, required this.name, required this.songs});
}

class MockSetlists {
  static const sl1 = Setlist(
    id: 'sl1',
    name: 'Ensayo semanal',
    songs: [
      SetlistSong(title: 'Bohemian Rhapsody', artist: 'Queen', duration: '5:55'),
      SetlistSong(title: "Livin' on a Prayer", artist: 'Bon Jovi', duration: '4:09'),
      SetlistSong(title: 'No Woman No Cry', artist: 'Bob Marley', duration: '4:15'),
      SetlistSong(title: 'Volver a los 17', artist: 'Violeta Parra', duration: '3:40'),
    ],
  );
}
