import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:control_del_tiempo/provider/time_entry_provider.dart';
import 'package:control_del_tiempo/screens/home_screen.dart';
import 'package:localstorage/localstorage.dart';
import 'package:control_del_tiempo/provider/task_provider.dart';
import 'package:control_del_tiempo/provider/project_provider.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimeEntryProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
      ],
      child: const MainApp(),
    ),
  );
}


class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Time management app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00A576),
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarThemeData(
          backgroundColor: Color(0xFF00A576),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFFFD600),
          foregroundColor: Colors.black,
        ),
      ),
      home: HomeScreen(),
    );
  }
}