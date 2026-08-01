/// Corresponde a /bands/{bandId}/chat/{messageId} en Firestore.
enum ChatMessageType { text, system }

class ChatMessage {
  final String id;
  final String senderName;
  final String? senderId; // null para mensajes de sistema
  final String text;
  final DateTime sentAt;
  final ChatMessageType type;

  const ChatMessage({
    required this.id,
    required this.senderName,
    this.senderId,
    required this.text,
    required this.sentAt,
    this.type = ChatMessageType.text,
  });
}

/// Datos mock para desarrollar la UI sin depender todavía de Firestore.
class MockChat {
  static const currentUserId = 'u_lucas';

  static final messages = [
    ChatMessage(
      id: '1',
      senderName: 'sistema',
      text: 'Ana actualizó Bohemian Rhapsody · Si♭ mayor',
      sentAt: DateTime.now().subtract(const Duration(hours: 3)),
      type: ChatMessageType.system,
    ),
    ChatMessage(
      id: '2',
      senderName: 'Ana',
      senderId: 'u_ana',
      text: 'Che, la subí de tono para que la cante mejor Diego',
      sentAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 58)),
    ),
    ChatMessage(
      id: '3',
      senderName: 'Lucas',
      senderId: currentUserId,
      text: 'Buenísimo, la ensayo así entonces',
      sentAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 57)),
    ),
    ChatMessage(
      id: '4',
      senderName: 'Diego',
      senderId: 'u_diego',
      text: 'Gracias! Alguien tiene la tab del solo?',
      sentAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 55)),
    ),
    ChatMessage(
      id: '5',
      senderName: 'sistema',
      text: 'Lucas agregó un ensayo: Viernes 19:00hs',
      sentAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 20)),
      type: ChatMessageType.system,
    ),
    ChatMessage(
      id: '6',
      senderName: 'Lucas',
      senderId: currentUserId,
      text: 'Ahí la subo, la tengo en el celu',
      sentAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 15)),
    ),
  ];
}
