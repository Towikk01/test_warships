import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_warships/core/views/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Makes the status bar transparent
      statusBarIconBrightness: Brightness.light, // Light icons
      systemNavigationBarColor:
          Colors.transparent, // Optional for the bottom nav bar
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Battleship game',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[200],
          elevation: 0,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        primarySwatch: Colors.orange,
      ),
      home: const HomeScreen(),
    );
  }
}
