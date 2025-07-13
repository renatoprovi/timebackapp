import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SimuladorScreen extends StatelessWidget {
  const SimuladorScreen({super.key});

  Future<void> _setUsedMinutes(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('usedMinutes', minutes);
  }

  Future<void> _setBonusMinutes(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('bonusMinutes', minutes);
  }

  Future<void> _setModoBloqueio(String modo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('modoBloqueio', modo);
  }

  Future<void> _setNewDay({bool ultrapassouOntem = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().subtract(const Duration(days: 1));
    final formatted = '${now.year}-${now.month}-${now.day}';
    await prefs.setString('lastUsageDate', formatted);
    await prefs.setBool('yesterdayExceeded', ultrapassouOntem);
  }

  Future<void> _clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simulador de Cenários')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            const Text('⏱ Tempo de uso:', style: TextStyle(fontSize: 18)),
            ElevatedButton(
              onPressed: () => _setUsedMinutes(120),
              child: const Text('Usar 120 minutos'),
            ),
            ElevatedButton(
              onPressed: () => _setUsedMinutes(0),
              child: const Text('Zerar uso'),
            ),
            const SizedBox(height: 24),
            const Text('🎁 Bônus:', style: TextStyle(fontSize: 18)),
            ElevatedButton(
              onPressed: () => _setBonusMinutes(15),
              child: const Text('Dar 15 minutos de bônus'),
            ),
            ElevatedButton(
              onPressed: () => _setBonusMinutes(0),
              child: const Text('Zerar bônus'),
            ),
            const SizedBox(height: 24),
            const Text('📅 Dia simulado:', style: TextStyle(fontSize: 18)),
            ElevatedButton(
              onPressed: () => _setNewDay(ultrapassouOntem: true),
              child: const Text('Simular novo dia (ultrapassou limite)'),
            ),
            ElevatedButton(
              onPressed: () => _setNewDay(ultrapassouOntem: false),
              child: const Text('Simular novo dia (ganha bônus)'),
            ),
            const SizedBox(height: 24),
            const Text('🔐 Modo de bloqueio:', style: TextStyle(fontSize: 18)),
            ElevatedButton(
              onPressed: () => _setModoBloqueio('ModoBloqueio.pago'),
              child: const Text('Definir como "Pago"'),
            ),
            ElevatedButton(
              onPressed: () => _setModoBloqueio('ModoBloqueio.forcaDeVontade'),
              child: const Text('Definir como "Força de Vontade"'),
            ),
            const SizedBox(height: 24),
            const Divider(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                await _clearAll();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Todos os dados foram apagados')),
                  );
                }
              },
              child: const Text('🧨 Resetar todos os dados'),
            ),
          ],
        ),
      ),
    );
  }
}
