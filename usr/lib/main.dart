import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const QBotApp());
}

class QBotApp extends StatelessWidget {
  const QBotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Q-Bot 2.0',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1A1A2E),
        cardColor: const Color(0xFF16213E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F3460),
          elevation: 0,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
