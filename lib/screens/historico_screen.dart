// lib/screens/historico_screen.dart
import 'package:flutter/material.dart';
import '../utils/historico_storage.dart';

class HistoricoScreen extends StatefulWidget {
  const HistoricoScreen({super.key});

  @override
  State<HistoricoScreen> createState() => _HistoricoScreenState();
}

class _HistoricoScreenState extends State<HistoricoScreen> {
  Map<String, int> historico = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    final dados = await HistoricoStorage.carregarHistorico();
    setState(() {
      historico = dados;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de Uso')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: historico.entries.map((entry) {
          final data = entry.key;
          final minutos = entry.value;
          final dentroLimite = minutos <= 60;
          return ListTile(
            title: Text('📅 $data'),
            subtitle: Text('$minutos minutos usados'),
            trailing: Icon(
              dentroLimite ? Icons.check_circle : Icons.warning,
              color: dentroLimite ? Colors.green : Colors.red,
            ),
          );
        }).toList(),
      ),
    );
  }
}
