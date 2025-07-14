import 'package:flutter/material.dart';
import '../utils/historico_storage.dart';

/// Tela que exibe o histórico de uso diário dos minutos consumidos.
///
/// Mostra uma lista com as datas e o tempo usado, indicando se o uso
/// ficou dentro do limite permitido.
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
    _carregarHistorico();
  }

  /// Carrega os dados do histórico de uso armazenados.
  ///
  /// Atualiza o estado da tela com os dados carregados.
  Future<void> _carregarHistorico() async {
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
