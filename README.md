
# 🤖 AI Chat - Flutter Gemini API Chat Application

A modern Flutter chat application that integrates with Google's Gemini AI to provide intelligent conversational experiences with smooth UI animations and markdown rendering.

![Flutter](https://img.shields.io/badge/Flutter-3.19-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.2-blue?logo=dart)
![Gemini API](https://img.shields.io/badge/Gemini-API-orange?logo=google)

## ✨ Features

- **🤖 Gemini AI Integration**: Seamless connection with Google's Gemini 1.5 Flash model
- **🎨 Beautiful UI**: Clean, modern chat interface with message bubbles
- **⌨️ Typing Animation**: Smooth typing effect for AI responses
- **📝 Markdown Support**: Rendered markdown responses using `gpt_markdown` package
- **🔄 Real-time Updates**: Auto-scrolling to latest messages
- **🎯 Error Handling**: Comprehensive error handling for API failures
- **📱 Responsive Design**: Works on both mobile and desktop platforms
## 📸 Screenshots



| Screen-1 | Screen-2 |
|---------------|--------------|
| ![](/assets/SS/photo_2025-08-30%2003.51.51.jpeg) | ![](/assets/SS/photo_2025-08-30%2003.51.53.jpeg) |

| Screen-3  | Screen-4 |
|-----------|-----------|
| ![](/assets/SS/photo_2025-08-30%2003.51.56.jpeg) | ![](/assets/SS/photo_2025-08-30%2003.51.59.jpeg) |



## 🚀 Getting Started

### Prerequisites

- Flutter SDK (version 3.19.0 or higher)
- Dart (version 3.2 or higher)
- Google Gemini API key

### Installation

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd ai-chat-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Add your Gemini API key**
    - Get your API key from [Google AI Studio](https://makersuite.google.com/app/apikey)
    - Replace the placeholder in `home_page.dart`:
   ```dart
   const String apiKey = "YOUR_ACTUAL_API_KEY_HERE";
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

## 📦 Dependencies

The project uses the following packages:

- **flutter**: Core Flutter framework
- **http**: For making API requests to Gemini
- **gpt_markdown**: For rendering markdown text in chat messages

Add these to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  gpt_markdown: ^0.0.5
```

## 🏗️ Project Structure

```
lib/
├── main.dart          # Application entry point
├── home_page.dart     # Main chat screen implementation
```

### Key Components

- **`HomePage`**: Main stateful widget for the chat interface
- **`_HomePageState`**: Manages chat state and API communication
- **`TypingText`**: Widget for animated typing effect
- **`TypingIndicator`**: Loading animation while AI processes

## 🔧 API Configuration

The app uses Google's Gemini API with the following configuration:

```dart
final String url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey";
```

### Request Format
```json
{
  "contents": [
    {
      "parts": [
        {"text": "User message here"}
      ]
    }
  ]
}
```

## 🎨 Customization

### Styling
- Modify colors in `BoxDecoration` for message bubbles
- Adjust animation timing in `Timer.periodic` and `Duration` values
- Change font sizes in `TextStyle` properties

### Features
- Add message persistence with local storage
- Implement conversation history
- Add support for different AI models
- Include image/attachment support

## ⚠️ Security Notes

- **Never commit API keys** to version control
- Consider using environment variables or secure storage for API keys
- For production, use a backend server to handle API requests instead of making them directly from the client

## 🐛 Troubleshooting

### Common Issues

1. **API Key Errors**
    - Ensure your Gemini API key is valid and has proper permissions
    - Check your Google Cloud billing setup

2. **Network Errors**
    - Verify internet connection
    - Check if the Gemini API is accessible from your region

3. **Build Errors**
    - Run `flutter clean` and `flutter pub get`
    - Ensure all dependencies are compatible

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check:

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📞 Support

If you have any questions or need help, please:

1. Check the [Flutter documentation](https://flutter.dev/docs)
2. Review the [Gemini API documentation](https://ai.google.dev/)
3. Open an issue in this repository

---
## 👤 Author and Contact

**Abdullah Nazmus Sakib**  
Computer Science & Engineering @ Jahangirnagar University  
Passionate about clean UI, scalable systems, and delightful user experiences.

🔗 [LinkedIn](https://www.linkedin.com/in/abdullah-nazmus-sakib-04024b261/)  
🐙 [GitHub](https://github.com/AbdullahRFA)

---

