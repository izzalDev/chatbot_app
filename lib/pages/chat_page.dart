import 'dart:convert';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatUser _currentUser =
      ChatUser(id: '1', firstName: 'rizal', lastName: 'fadlullah');
  final ChatUser _botUser =
      ChatUser(id: '2', firstName: 'bot', lastName: 'user');
  List<ChatMessage> _messages = <ChatMessage>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chatbot App"),
      ),
      body: DashChat(
        currentUser: _currentUser,
        onSend: (ChatMessage m) {
          getChatResponse(m);
        },
        messages: _messages,
        inputOptions: const InputOptions(
          sendOnEnter: true,
        ),
      ),
    );
  }

  Future<void> _sendRequest(String text) async {
    final apiUrl = 'https://api-chatbot.izzal.my.id/predict';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': text}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newMessage = ChatMessage(
          text: data['prediction'],
          user: _botUser,
          createdAt: DateTime.now(),
        );
        setState(() {
          _messages.insert(0, newMessage);
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> getChatResponse(ChatMessage m) async {
    setState(() {
      _messages.insert(0, m);
      _sendRequest(m.text);
    });
  }
}
