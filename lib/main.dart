import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'screens/modo_escolha_screen.dart';
// ignore: unused_import
import '../models/modo_bloqueio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TimeBackApp());
}

class TimeBackApp extends StatelessWidget {
  const TimeBackApp({super.key});

  Future<Widget> _decidirTelaInicial() async {
    final prefs = await SharedPreferences.getInstance();
    final modo = prefs.getString('modoBloqueio');
    if (modo == null) {
      return const ModoEscolhaScreen();
    } else {
      return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TimeBack',
      debugShowCheckedModeBanner: false, // 👈 Remove o selo DEBUG
      themeMode: ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: FutureBuilder<Widget>(
        future: _decidirTelaInicial(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return snapshot.data!;
        },
      ),
    );
  }
}

