import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();
  String response = '';

  // Future<void> getResponse() async {
  //   const String apiKey = "AIzaSyAohznfnNbj-R6yvNGU89UNQGzrUKeMp7k"; // 🔒 Replace with your Gemini key
  //   final String url =
  //       "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey";
  //
  //   Map<String, dynamic> bodyParams = {
  //     "contents": [
  //       {
  //         "parts": [
  //           {"text": searchController.text}
  //         ]
  //       }
  //     ]
  //   };
  //
  //   try {
  //     final res = await http.post(
  //       Uri.parse(url),
  //       headers: {
  //         "Content-Type": "application/json",
  //       },
  //       body: jsonEncode(bodyParams),
  //     );
  //
  //     if (res.statusCode == 200) {
  //       final data = jsonDecode(res.body);
  //       final output = data["candidates"]?[0]["content"]?["parts"]?[0]?["text"] ?? "No response";
  //       setState(() {
  //         response = output;
  //       });
  //     } else {
  //       print(res.statusCode);
  //       print(res.body);
  //       setState(() {
  //         response = "Error: ${res.statusCode} → ${res.body}";
  //       });
  //     }
  //   } catch (e) {
  //     print(e);
  //     setState(() {
  //       response = "Exception: $e";
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Chat")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Ask me anything...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                if (searchController.text.isNotEmpty) {
                  getResponse();
                }
              },
              child: const Text("Send"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  response,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getResponse() async{
    String apiKey = "AIzaSyAohznfnNbj-R6yvNGU89UNQGzrUKeMp7k";
    String url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey";

    Map<String,dynamic> bodyParams = {

        "contents": [
          {
            "parts": [
              {
                "text": searchController.text
              }
            ]
          }
        ]

    };

    var res = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(bodyParams),
    );

    if(res.statusCode == 200){
      print(res.body);
    }
  }


}