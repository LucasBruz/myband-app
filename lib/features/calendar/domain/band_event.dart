/// Corresponde a /bands/{bandId}/events/{eventId} en Firestore.
enum EventType { rehearsal, show }

enum AttendanceStatus { confirmed, pending, declined }

class BandMemberAttendance {
  final String name;
  final AttendanceStatus status;

  const BandMemberAttendance({required this.name, required this.status});
}

class BandEvent {
  final String id;
  final String title;
  final DateTime date;
  final String timeRange; // ej. "19:00hs - 21:00hs"
  final String location;
  final EventType type;
  final String? setlistId;
  final List<BandMemberAttendance> attendance;

  const BandEvent({
    required this.id,
    required this.title,
    required this.date,
    required this.timeRange,
    required this.location,
    required this.type,
    this.setlistId,
    this.attendance = const [],
  });
}

class MockEvents {
  static final list = [
    BandEvent(
      id: 'e1',
      title: 'Ensayo semanal',
      date: DateTime.now().add(const Duration(days: 2)),
      timeRange: '19:00hs - 21:00hs',
      location: 'Estudio Central, sala 3',
      type: EventType.rehearsal,
      setlistId: 'sl1',
      attendance: const [
        BandMemberAttendance(name: 'Lucas', status: AttendanceStatus.confirmed),
        BandMemberAttendance(name: 'Ana', status: AttendanceStatus.confirmed),
        BandMemberAttendance(name: 'Diego', status: AttendanceStatus.pending),
        BandMemberAttendance(name: 'Mica', status: AttendanceStatus.confirmed),
      ],
    ),
    BandEvent(
      id: 'e2',
      title: 'Show en El Teatrito',
      date: DateTime.now().add(const Duration(days: 10)),
      timeRange: '22:00hs',
      location: 'El Teatrito',
      type: EventType.show,
      setlistId: 'sl1',
    ),
    BandEvent(
      id: 'e3',
      title: 'Ensayo semanal',
      date: DateTime.now().add(const Duration(days: 16)),
      timeRange: '19:00hs - 21:00hs',
      location: 'Estudio Central, sala 3',
      type: EventType.rehearsal,
    ),
  ];
}
