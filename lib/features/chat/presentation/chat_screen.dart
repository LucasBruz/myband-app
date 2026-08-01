import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_widgets.dart';
import '../domain/chat_message.dart';

/// Chat en tiempo real de la banda. Los mensajes de tipo `system` se
/// generan automáticamente (no los escribe nadie) cuando el admin
/// modifica una canción o crea un evento — así el chat también sirve
/// como feed de actividad, sin que el músico tenga que ir a buscarlo.
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            const AppLogo(size: 36),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Los del Ensayo',
                    style: TextStyle(
                        color: AppColors.text,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                Text('4 en línea',
                    style: TextStyle(color: AppColors.muted, fontSize: 10)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: MockChat.messages.length,
              itemBuilder: (context, i) {
                final msg = MockChat.messages[i];
                if (msg.type == ChatMessageType.system) {
                  return _SystemBubble(msg: msg);
                }
                final mine = msg.senderId == MockChat.currentUserId;
                return _ChatBubble(msg: msg, mine: mine);
              },
            ),
          ),
          const _MessageInput(),
        ],
      ),
    );
  }
}

class _SystemBubble extends StatelessWidget {
  final ChatMessage msg;
  const _SystemBubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.music_note, size: 12, color: AppColors.lime),
            const SizedBox(width: 6),
            Text(msg.text,
                style: const TextStyle(color: AppColors.muted, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage msg;
  final bool mine;
  const _ChatBubble({required this.msg, required this.mine});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!mine)
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 2),
              child: Text(msg.senderName,
                  style:
                      const TextStyle(color: AppColors.muted, fontSize: 10)),
            ),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.72),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 3),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: mine ? AppColors.lime : AppColors.card,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                msg.text,
                style: TextStyle(
                  color: mine ? AppColors.onLime : AppColors.text,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              DateFormat.Hm().format(msg.sentAt),
              style: const TextStyle(color: AppColors.muted, fontSize: 9),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageInput extends StatelessWidget {
  const _MessageInput();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFF1C1C22))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(999),
              ),
              child: const TextField(
                style: TextStyle(color: AppColors.text, fontSize: 13),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Escribir mensaje...',
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              // TODO: enviar a /bands/{bandId}/chat vía Cloud Firestore
              // (addDoc con senderId, text, createdAt, type: 'text')
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                  color: AppColors.lime, shape: BoxShape.circle),
              child: const Icon(Icons.send_rounded,
                  size: 16, color: AppColors.onLime),
            ),
          ),
        ],
      ),
    );
  }
}
