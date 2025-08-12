import 'package:flutter/material.dart';
import 'package:medicine_reminder/ui/screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'お薬リマインダー',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HomeScreen(), // ← これで起動時にHomeScreenが出る
      // ルーティングを使うならこんな感じで追加してもOK
      // routes: {
      //   '/home': (_) => const HomeScreen(),
      //   '/settings': (_) => const SettingsScreen(),
      // },
      // initialRoute: '/home',
    );
  }
}