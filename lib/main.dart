import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:medicine_reminder/ui/screen/home_screen.dart';
import 'package:upgrader/upgrader.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          supportedLocales: const [
            Locale('ja', 'JP'),
          ],
          title: 'お薬リマインダー',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
            useMaterial3: true,
              fontFamily: 'Noto Sans JP'
          ),
          home: UpgradeAlert(
            upgrader: Upgrader(
              debugDisplayAlways: false,
              debugLogging: true,
              countryCode: 'JP',
            ),
            child: const HomeScreen(),
          // ルーティングを使うならこんな感じで追加してもOK
          // routes: {
          //   '/home': (_) => const HomeScreen(),
          //   '/settings': (_) => const SettingsScreen(),
          // },
          // initialRoute: '/home',
        ),
    );
  }
}