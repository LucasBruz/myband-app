import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/groups/presentation/band_choice_screen.dart';
import '../../features/groups/presentation/create_band_screen.dart';
import '../../features/groups/presentation/join_band_screen.dart';
import '../../features/groups/presentation/home_screen.dart';
import '../../features/songs/domain/song.dart';
import '../../features/songs/presentation/library_screen.dart';
import '../../features/songs/presentation/song_detail_screen.dart';
import '../../features/songs/presentation/song_history_screen.dart';
import '../../features/metronome/presentation/metronome_screen.dart';
import '../../features/chat/presentation/chat_screen.dart';
import '../../features/calendar/domain/band_event.dart';
import '../../features/calendar/presentation/calendar_screen.dart';
import '../../features/calendar/presentation/event_detail_screen.dart';
import '../../features/setlists/presentation/setlist_screen.dart';
import '../../features/practice_space/presentation/profile_screen.dart';
import '../../features/practice_space/presentation/favorites_screen.dart';
import '../../features/practice_space/presentation/notes_screen.dart';
import '../../features/admin/presentation/admin_overview_screen.dart';
import '../../features/admin/presentation/admin_members_screen.dart';
import '../../features/admin/presentation/admin_moderation_screen.dart';

/// Rutas de Fase 1, 2 y 3. A medida que se agregue el espacio privado
/// del músico se suma acá.
final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
    GoRoute(
        path: '/band-choice', builder: (_, __) => const BandChoiceScreen()),
    GoRoute(
        path: '/create-band', builder: (_, __) => const CreateBandScreen()),
    GoRoute(path: '/join-band', builder: (_, __) => const JoinBandScreen()),
    GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/library', builder: (_, __) => const LibraryScreen()),
    GoRoute(
      path: '/song',
      builder: (_, state) {
        final song = state.extra as Song? ?? MockSongs.list.first;
        return SongDetailScreen(song: song);
      },
    ),
    GoRoute(
      path: '/song-history',
      builder: (_, __) =>
          SongHistoryScreen(versions: MockSongs.versions),
    ),
    GoRoute(
      path: '/metronome',
      builder: (_, state) {
        final args = state.extra as Map<String, dynamic>?;
        return MetronomeScreen(
          songTitle: args?['songTitle'] as String? ?? 'Metrónomo libre',
          initialBpm: args?['bpm'] as int? ?? 120,
        );
      },
    ),
    GoRoute(path: '/chat', builder: (_, __) => const ChatScreen()),
    GoRoute(path: '/calendar', builder: (_, __) => const CalendarScreen()),
    GoRoute(
      path: '/event',
      builder: (_, state) {
        final event = state.extra as BandEvent? ?? MockEvents.list.first;
        return EventDetailScreen(event: event);
      },
    ),
    GoRoute(
      path: '/setlist',
      builder: (_, state) {
        final args = state.extra as Map<String, dynamic>?;
        return SetlistScreen(
          eventTitle: args?['eventTitle'] as String? ?? 'Setlist',
        );
      },
    ),
    GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
    GoRoute(path: '/favorites', builder: (_, __) => const FavoritesScreen()),
    GoRoute(path: '/notes', builder: (_, __) => const NotesScreen()),
    GoRoute(
        path: '/admin', builder: (_, __) => const AdminOverviewScreen()),
    GoRoute(
        path: '/admin/members',
        builder: (_, __) => const AdminMembersScreen()),
    GoRoute(
        path: '/admin/moderation',
        builder: (_, __) => const AdminModerationScreen()),
  ],
);


