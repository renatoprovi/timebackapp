import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/modo_bloqueio.dart';
import 'penalty_screen.dart';
import '../utils/historico_storage.dart';
import 'historico_screen.dart';
import 'simulador_screen.dart'; // << NOVO

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int dailyLimit = 60;
  int usedMinutes = 0;
  int bonusMinutes = 0;
  bool isLoading = true;

  final List<String> popularApps = [
    'Instagram',
    'TikTok',
    'WhatsApp',
    'YouTube',
    'Facebook',
    'Twitter/X',
  ];

  Set<String> selectedApps = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      dailyLimit = prefs.getInt('dailyLimit') ?? 60;
      usedMinutes = prefs.getInt('usedMinutes') ?? 0;
      bonusMinutes = prefs.getInt('bonusMinutes') ?? 0;
      selectedApps = (prefs.getStringList('selectedApps') ?? []).toSet();
      isLoading = false;
    });
  }

  Future<void> _saveDailyLimit() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('dailyLimit', dailyLimit);
  }

  Future<void> _saveUsedMinutes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('usedMinutes', usedMinutes);
  }

  Future<void> _saveBonusMinutes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('bonusMinutes', bonusMinutes);
  }

  Future<void> _saveSelectedApps() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('selectedApps', selectedApps.toList());
  }

  void _incrementUsedMinutes() {
    setState(() {
      usedMinutes += 5;
    });
    _saveUsedMinutes();
    HistoricoStorage.salvarUsoHoje(usedMinutes);
  }

  Future<String?> _getModoBloqueio() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('modoBloqueio');
  }

  Future<void> _checkDailyReset() async {
    final prefs = await SharedPreferences.getInstance();
    final lastDateString = prefs.getString('lastUsageDate');
    final now = DateTime.now();
    final todayString = '${now.year}-${now.month}-${now.day}';

    if (lastDateString != todayString) {
      final yesterdayExceeded = prefs.getBool('yesterdayExceeded') ?? false;
      if (!yesterdayExceeded) {
        bonusMinutes += 10;
        await _saveBonusMinutes();
      }
      await prefs.setBool('yesterdayExceeded', usedMinutes >= dailyLimit);
      usedMinutes = 0;
      await _saveUsedMinutes();
      await prefs.setString('lastUsageDate', todayString);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    _checkDailyReset();

    bool exceeded = usedMinutes >= (dailyLimit + bonusMinutes);

    if (exceeded) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final modo = await _getModoBloqueio();
        if (modo == ModoBloqueio.pago.toString()) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => PenaltyScreen(
                onPaid: () async {
                  final prefs = await SharedPreferences.getInstance();
                  int extraTime = 30;
                  int currentLimit = prefs.getInt('dailyLimit') ?? 60;
                  await prefs.setInt('dailyLimit', currentLimit + extraTime);
                  usedMinutes = 0;
                  bonusMinutes = 0;
                  await _saveUsedMinutes();
                  await _saveBonusMinutes();
                },
              ),
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Limite Excedido'),
              content: const Text('Você excedeu seu tempo diário.\nVolte amanhã!'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                )
              ],
            ),
          );
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('TimeBack'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Histórico',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const HistoricoScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Defina seu limite diário de uso (minutos):',
              style: TextStyle(fontSize: 18),
            ),
            Slider(
              value: dailyLimit.toDouble(),
              min: 15,
              max: 300,
              divisions: 19,
              label: '$dailyLimit min',
              onChanged: (value) {
                setState(() {
                  dailyLimit = value.toInt();
                });
              },
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await _saveDailyLimit();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Limite diário salvo: $dailyLimit minutos'),
                    ),
                  );
                },
                child: const Text('Salvar Limite'),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Escolha os apps que deseja limitar:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            ...popularApps.map((app) {
              return CheckboxListTile(
                title: Text(app),
                value: selectedApps.contains(app),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      selectedApps.add(app);
                    } else {
                      selectedApps.remove(app);
                    }
                    _saveSelectedApps();
                  });
                },
              );
            }).toList(),
            const SizedBox(height: 30),
            Text(
              'Tempo usado hoje: $usedMinutes minutos',
              style: TextStyle(
                fontSize: 18,
                color: exceeded ? Colors.red : Colors.black,
                fontWeight: exceeded ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Text(
              'Bônus acumulado: $bonusMinutes minutos',
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _incrementUsedMinutes,
              child: const Text('Simular +5 minutos de uso'),
            ),
            const SizedBox(height: 30),
            Divider(),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SimuladorScreen()),
                  );
                },
                child: const Text(
                  '🔬 Acessar Simulador de TCC',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


