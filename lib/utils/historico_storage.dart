// lib/utils/historico_storage.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HistoricoStorage {
  static const _key = 'historico_uso';

  static Future<Map<String, int>> carregarHistorico() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return {};
    final Map<String, dynamic> decoded = json.decode(jsonString);
    return decoded.map((k, v) => MapEntry(k, v as int));
  }

  static Future<void> salvarUsoHoje(int minutos) async {
    final prefs = await SharedPreferences.getInstance();
    final historico = await carregarHistorico();

    final hoje = _dataHojeString();
    historico[hoje] = minutos;

    // Limita a 7 dias
    final diasOrdenados = historico.keys.toList()
      ..sort((a, b) => b.compareTo(a));
    final ultimos7 = Map.fromEntries(
        diasOrdenados.take(7).map((d) => MapEntry(d, historico[d]!)));

    await prefs.setString(_key, json.encode(ultimos7));
  }

  static String _dataHojeString() {
    final agora = DateTime.now();
    return '${agora.year}-${agora.month.toString().padLeft(2, '0')}-${agora.day.toString().padLeft(2, '0')}';
  }
}
