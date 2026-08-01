import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../calendar/domain/band_event.dart';
import '../../chat/domain/chat_message.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // TODO: reemplazar por datos reales desde providers Riverpod
  // conectados a Firestore (/bands/{bandId}, próximo evento, etc.)
  static const bandName = 'Los del Ensayo';
  static const attendanceBars = [40.0, 65.0, 30.0, 90.0, 55.0, 20.0, 70.0];
  static const days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

  @override
  Widget build(BuildContext context) {
    final nextEvent = MockEvents.list.first;
    final recentMessages = MockChat.messages.reversed.take(2).toList().reversed.toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  const AppLogo(size: 22),
                  const SizedBox(width: 8),
                  const Text('MYBAND',
                      style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 11,
                          letterSpacing: 2)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: AppColors.lime,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('L',
                          style: TextStyle(
                              color: AppColors.onLime,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('BIENVENIDO A',
                            style: TextStyle(
                                color: AppColors.muted,
                                fontSize: 10,
                                letterSpacing: 0.5)),
                        Text(bandName,
                            style: TextStyle(
                                color: AppColors.text,
                                fontSize: 14,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Icon(Icons.notifications_outlined,
                        color: AppColors.muted, size: 16),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(child: _StatCard(label: 'Canciones', value: '24')),
                        const SizedBox(width: 8),
                        const Expanded(child: _StatCard(label: 'Asistencia', value: '92%')),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _StatCard(
                            label: 'Sin leer',
                            value: '${MockChat.messages.length}',
                            sub: 'en el chat',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text('PRÓXIMO EVENTO',
                        style: TextStyle(
                            color: AppColors.muted,
                            fontSize: 11,
                            letterSpacing: 0.5)),
                    const SizedBox(height: 8),
                    _NextEventCard(event: nextEvent),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('ACTIVIDAD RECIENTE',
                            style: TextStyle(
                                color: AppColors.muted,
                                fontSize: 11,
                                letterSpacing: 0.5)),
                        GestureDetector(
                          onTap: () => context.push('/chat'),
                          child: const Text('Ver chat',
                              style: TextStyle(color: AppColors.lime, fontSize: 11)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _RecentActivityCard(messages: recentMessages),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('ASISTENCIA SEMANAL',
                            style: TextStyle(
                                color: AppColors.muted,
                                fontSize: 11,
                                letterSpacing: 0.5)),
                        Text('Promedio 68%',
                            style: TextStyle(color: AppColors.lime, fontSize: 11)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 110,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(attendanceBars.length, (i) {
                          final isHighlight = i == 3;
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 18,
                                height: attendanceBars[i] * 0.6,
                                decoration: BoxDecoration(
                                  color: isHighlight
                                      ? AppColors.lime
                                      : const Color(0xFF3A3B40),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(days[i],
                                  style: const TextStyle(
                                      color: AppColors.muted, fontSize: 10)),
                            ],
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('PRÓXIMA CANCIÓN A ENSAYAR',
                            style: TextStyle(
                                color: AppColors.muted,
                                fontSize: 11,
                                letterSpacing: 0.5)),
                        Text('Ver todas',
                            style: TextStyle(color: AppColors.lime, fontSize: 11)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Material(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => context.push(
                          '/metronome',
                          extra: {'songTitle': 'Bohemian Rhapsody', 'bpm': 72},
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Bohemian Rhapsody',
                                        style: TextStyle(
                                            color: AppColors.text,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600)),
                                    SizedBox(height: 2),
                                    Text('Queen · 72 BPM · Si♭ mayor',
                                        style: TextStyle(
                                            color: AppColors.muted, fontSize: 12)),
                                  ],
                                ),
                              ),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: AppColors.lime,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.play_arrow,
                                    color: AppColors.onLime),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            _BottomNav(),
          ],
        ),
      ),
    );
  }
}

class _NextEventCard extends StatelessWidget {
  final BandEvent event;
  const _NextEventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.card2, AppColors.card],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.lime.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text('ENSAYO',
                    style: TextStyle(
                        fontSize: 9,
                        color: AppColors.lime,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(event.title,
              style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text('${event.timeRange}',
              style: const TextStyle(color: AppColors.muted, fontSize: 11)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  onPressed: () => context.push('/event', extra: event),
                  child: const Text('Confirmar', style: TextStyle(fontSize: 11)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  onPressed: () => context.push(
                    '/setlist',
                    extra: {'setlistId': event.setlistId, 'eventTitle': event.title},
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.queue_music, size: 13),
                      SizedBox(width: 4),
                      Text('Setlist', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecentActivityCard extends StatelessWidget {
  final List<ChatMessage> messages;
  const _RecentActivityCard({required this.messages});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/chat'),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            for (int i = 0; i < messages.length; i++) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    messages[i].type == ChatMessageType.system
                        ? Icons.music_note
                        : Icons.circle,
                    size: messages[i].type == ChatMessageType.system ? 13 : 6,
                    color: messages[i].type == ChatMessageType.system
                        ? AppColors.lime
                        : AppColors.muted,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      messages[i].type == ChatMessageType.system
                          ? messages[i].text
                          : '${messages[i].senderName}: ${messages[i].text}',
                      style: const TextStyle(
                          color: AppColors.text, fontSize: 11),
                    ),
                  ),
                ],
              ),
              if (i != messages.length - 1) ...[
                const SizedBox(height: 8),
                const Divider(height: 1, color: AppColors.border),
                const SizedBox(height: 8),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? sub;

  const _StatCard({required this.label, required this.value, this.sub});

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
          Text(value,
              style: const TextStyle(
                  color: AppColors.text, fontSize: 18, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 10)),
          if (sub != null)
            Text(sub!, style: const TextStyle(color: AppColors.lime, fontSize: 9)),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  static const _icons = [
    Icons.home_rounded,
    Icons.library_music_outlined,
    Icons.chat_bubble_outline,
    Icons.calendar_today_outlined,
    Icons.person_outline,
  ];
  static const _routes = ['/home', '/library', '/chat', '/calendar', '/profile'];
  static const _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F0F11),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_icons.length, (i) {
          final active = i == _activeIndex;
          return GestureDetector(
            onTap: () {
              if (!active) context.push(_routes[i]);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: active ? 44 : 36,
              height: active ? 44 : 36,
              decoration: BoxDecoration(
                color: active ? AppColors.lime : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _icons[i],
                size: 18,
                color: active ? AppColors.onLime : AppColors.muted,
              ),
            ),
          );
          // Nav completa: Home, Biblioteca, Chat, Calendario y Perfil
          // ya apuntan todas a pantallas reales.
        }),
      ),
    );
  }
}
