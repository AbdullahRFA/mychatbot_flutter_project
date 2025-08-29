// Import required Dart and Flutter packages
import 'dart:async'; // For Timer (typing effect)
import 'dart:convert'; // For encoding/decoding JSON
import 'package:flutter/material.dart'; // Core Flutter UI framework
import 'package:gpt_markdown/gpt_markdown.dart'; // For rendering Markdown text
import 'package:http/http.dart' as http; // For making HTTP requests

// Main chat screen widget
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// State class for HomePage
class _HomePageState extends State<HomePage> {
  // Controller for input text field
  final TextEditingController searchController = TextEditingController();

  // Controller for scrolling chat messages to bottom automatically
  final ScrollController _scrollController = ScrollController();

  // Stores chat messages (list of maps: {role: user/ai/typing, text: message})
  List<Map<String, String>> messages = [];

  // Function to call Gemini API and fetch AI response
  Future<void> getResponse(String query) async {
    // Gemini API Key (⚠️ Replace with your actual key securely)
    const String apiKey = "AIzaSyAohznfnNbj-R6yvNGU89UNQGzrUKeMp7k";

    // API endpoint (Gemini generateContent)
    final String url =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey";

    // Request body containing user message
    Map<String, dynamic> bodyParams = {
      "contents": [
        {
          "parts": [
            {"text": query} // User's message text
          ]
        }
      ]
    };

    try {
      // Send POST request to Gemini API
      final res = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"}, // Request headers
        body: jsonEncode(bodyParams), // Convert body to JSON
      );

      // Remove "typing..." indicator before showing response
      setState(() {
        messages.removeWhere((msg) => msg["role"] == "typing");
      });

      // ✅ Successful response
      if (res.statusCode == 200) {
        // Parse JSON response
        final data = jsonDecode(res.body);

        // Extract AI's response text (fallback to "⚠️ No response" if null)
        final output = data["candidates"]?[0]["content"]?["parts"]?[0]?["text"] ?? "⚠️ No response";

        // Add AI response to messages
        setState(() {
          messages.add({"role": "ai", "text": output});
        });

        // Scroll to bottom of chat
        _scrollToBottom();
      } else {
        // ❌ API error handling
        setState(() {
          messages.add({"role": "ai", "text": "❌ Error ${res.statusCode}: ${res.body}"});
        });
        _scrollToBottom();
      }
    } catch (e) {
      // ⚠️ Exception handling (network error, etc.)
      setState(() {
        messages.removeWhere((msg) => msg["role"] == "typing");
        messages.add({"role": "ai", "text": "⚠️ Exception: $e"});
      });
      _scrollToBottom();
    }
  }

  // Function triggered when user sends a message
  void sendMessage() {
    final text = searchController.text.trim(); // Get input text
    if (text.isEmpty) return; // Ignore if empty

    setState(() {
      // Add user's message
      messages.add({"role": "user", "text": text});

      // Clear input field
      searchController.clear();

      // Add typing indicator while waiting for AI response
      messages.add({"role": "typing", "text": "..."});
    });

    // Scroll down to latest message
    _scrollToBottom();

    // Call Gemini API with user text
    getResponse(text);
  }

  // Helper function to auto-scroll to bottom of chat
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent, // Scroll to last message
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar title
      appBar: AppBar(title: const Text("AI Chat")),
      body: Column(
        children: [
          // Chat message list
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // Auto-scroll controller
              padding: const EdgeInsets.all(12),
              itemCount: messages.length, // Number of messages
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isUser = msg["role"] == "user"; // Check if user message
                final isTyping = msg["role"] == "typing"; // Check if typing

                // Align message bubble based on sender
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    constraints: const BoxConstraints(maxWidth: 300), // Bubble width limit
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue[100] : Colors.grey[200], // Different colors
                      borderRadius: BorderRadius.circular(12),
                    ),
                    // Different UI for typing, user, AI
                    child: isTyping
                        ? const TypingIndicator() // Show "AI is typing..."
                        : isUser
                        ? Text(msg["text"] ?? "", style: const TextStyle(fontSize: 16))
                        : TypingText(msg["text"] ?? ""), // Animated AI text
                  ),
                );
              },
            ),
          ),

          // Input field + send button
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Text input
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Type a message...", // Placeholder
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Send button
                IconButton(
                  onPressed: sendMessage, // Trigger send
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

/// Widget to show AI typing response gradually (typing effect)
class TypingText extends StatefulWidget {
  final String text; // Full AI response text
  const TypingText(this.text, {super.key});

  @override
  State<TypingText> createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> {
  String displayedText = ""; // Text displayed so far
  int _index = 0; // Current character index
  Timer? _timer; // Timer for typing effect

  @override
  void initState() {
    super.initState();
    _startTyping(); // Start typing animation
  }

  // Function to reveal AI text gradually
  void _startTyping() {
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (_index < widget.text.length) {
        setState(() {
          displayedText += widget.text[_index]; // Add next character
          _index++;
        });
      } else {
        _timer?.cancel(); // Stop timer when text finished
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel timer to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Render markdown with typing effect
    return GptMarkdown(displayedText, style: const TextStyle(fontSize: 16));
  }
}

/// Widget showing "AI is typing..." animation
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller; // Controls animation
  late Animation<int> _dotCount; // Controls number of dots shown

  @override
  void initState() {
    super.initState();
    // Animation controller (1s loop)
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..repeat();

    // Animate between 1–3 dots
    _dotCount = StepTween(begin: 1, end: 3).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose(); // Clean up
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show "AI is typing..." with animated dots
    return AnimatedBuilder(
      animation: _dotCount,
      builder: (context, child) {
        return Text("AI is typing${"." * _dotCount.value}",
            style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic));
      },
    );
  }
}