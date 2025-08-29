import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Chat messages
  List<Map<String, String>> messages = [];

  Future<void> getResponse(String query) async {
    const String apiKey = "AIzaSyAohznfnNbj-R6yvNGU89UNQGzrUKeMp7k"; // 🔒 Replace with your Gemini key
    final String url =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey";

    Map<String, dynamic> bodyParams = {
      "contents": [
        {
          "parts": [
            {"text": query}
          ]
        }
      ]
    };

    try {
      final res = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bodyParams),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final output = data["candidates"]?[0]["content"]?["parts"]?[0]?["text"] ?? "⚠️ No response";

        setState(() {
          messages.add({"role": "ai", "text": output});
        });
        _scrollToBottom();
      } else {
        setState(() {
          messages.add({"role": "ai", "text": "❌ Error ${res.statusCode}: ${res.body}"});
        });
        _scrollToBottom();
      }
    } catch (e) {
      setState(() {
        messages.add({"role": "ai", "text": "⚠️ Exception: $e"});
      });
      _scrollToBottom();
    }
  }

  void sendMessage() {
    final text = searchController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({"role": "user", "text": text});
      searchController.clear();
    });
    _scrollToBottom();

    getResponse(text);
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Chat")),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isUser = msg["role"] == "user";

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    constraints: const BoxConstraints(maxWidth: 300),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: isUser
                        ? Text(msg["text"] ?? "", style: const TextStyle(fontSize: 16))
                        : TypingText(msg["text"] ?? ""),
                  ),
                );
              },
            ),
          ),

          // Input
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: sendMessage,
                  icon: const Icon(Icons.send),
                  color: Colors.blue,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Typing animation widget
class TypingText extends StatefulWidget {
  final String text;
  const TypingText(this.text, {super.key});

  @override
  State<TypingText> createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> {
  String displayedText = "";
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (_index < widget.text.length) {
        setState(() {
          displayedText += widget.text[_index];
          _index++;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GptMarkdown(displayedText, style: const TextStyle(fontSize: 16));
  }
}