import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Classe utilitária para armazenamento e recuperação do histórico de uso diário.
///
/// Utiliza SharedPreferences para persistência local no formato JSON.
class HistoricoStorage {
  static const _key = 'historico_uso';

  /// Carrega o histórico de uso armazenado.
  ///
  /// Retorna um Map onde a chave é a data no formato "yyyy-MM-dd"
  /// e o valor é o total de minutos usados naquele dia.
  /// Se não houver dados, retorna um Map vazio.
  static Future<Map<String, int>> carregarHistorico() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return {};
    final Map<String, dynamic> decoded = json.decode(jsonString);
    return decoded.map((k, v) => MapEntry(k, v as int));
  }

  /// Salva o uso do dia atual no histórico.
  ///
  /// Atualiza o valor de minutos para o dia de hoje.
  /// Limita o histórico aos últimos 7 dias para evitar crescimento indefinido.
  static Future<void> salvarUsoHoje(int minutos) async {
    final prefs = await SharedPreferences.getInstance();
    final historico = await carregarHistorico();

    final hoje = _dataHojeString();
    historico[hoje] = minutos;

    // Ordena as datas do histórico do mais recente para o mais antigo
    final diasOrdenados = historico.keys.toList()
      ..sort((a, b) => b.compareTo(a));
    // Mantém somente os últimos 7 dias no histórico
    final ultimos7 = Map.fromEntries(
      diasOrdenados.take(7).map((d) => MapEntry(d, historico[d]!))
    );

    await prefs.setString(_key, json.encode(ultimos7));
  }

  /// Retorna a data atual formatada como string no padrão "yyyy-MM-dd".
  static String _dataHojeString() {
    final agora = DateTime.now();
    return '${agora.year}-${agora.month.toString().padLeft(2, '0')}-${agora.day.toString().padLeft(2, '0')}';
  }
}

