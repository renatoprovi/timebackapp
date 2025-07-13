// lib/main.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'screens/modo_escolha_screen.dart';
import 'models/modo_bloqueio.dart';

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
