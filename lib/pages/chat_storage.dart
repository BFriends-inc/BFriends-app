class ChatStorage {
  static final Map<String, List<String>> _chatMessages = {};

  static List<String> getMessages(String friendName) {
    return _chatMessages.putIfAbsent(friendName, () => []);
  }

  static void addMessage(String friendName, String message) {
    final messages = _chatMessages.putIfAbsent(friendName, () => []);
    messages.add(message);
  }
}
