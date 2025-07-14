import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/modo_bloqueio.dart';
import 'penalty_screen.dart';
import '../utils/historico_storage.dart';
import 'historico_screen.dart';
import 'simulador_screen.dart'; // << NOVO

/// Representa um app popular com nome e ícone para seleção.
class AppInfo {
  final String nome;
  final IconData icone;

  AppInfo({required this.nome, required this.icone});
}

/// Tela principal do app TimeBack.
///
/// Permite definir o limite diário, selecionar apps para limitar,
/// mostra tempo usado, bônus e simula uso.
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

  final List<AppInfo> popularApps = [
    AppInfo(nome: 'Instagram', icone: Icons.camera_alt),
    AppInfo(nome: 'TikTok', icone: Icons.music_note),
    AppInfo(nome: 'WhatsApp', icone: Icons.chat),
    AppInfo(nome: 'YouTube', icone: Icons.ondemand_video),
    AppInfo(nome: 'Facebook', icone: Icons.facebook),
    AppInfo(nome: 'Twitter/X', icone: Icons.alternate_email),
  ];

  Set<String> selectedApps = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Carrega dados salvos nas preferências compartilhadas.
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

  /// Salva o limite diário nas preferências.
  Future<void> _saveDailyLimit() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('dailyLimit', dailyLimit);
  }

  /// Salva os minutos usados nas preferências.
  Future<void> _saveUsedMinutes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('usedMinutes', usedMinutes);
  }

  /// Salva os minutos bônus nas preferências.
  Future<void> _saveBonusMinutes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('bonusMinutes', bonusMinutes);
  }

  /// Salva os apps selecionados nas preferências.
  Future<void> _saveSelectedApps() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('selectedApps', selectedApps.toList());
  }

  /// Incrementa o uso em 5 minutos e salva o valor.
  void _incrementUsedMinutes() {
    setState(() {
      usedMinutes += 5;
    });
    _saveUsedMinutes();
    HistoricoStorage.salvarUsoHoje(usedMinutes);
  }

  /// Obtém o modo de bloqueio salvo.
  Future<String?> _getModoBloqueio() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('modoBloqueio');
  }

  /// Verifica se deve resetar o contador diário e aplicar bônus.
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

    // Verifica e reseta o uso diário se necessário
    _checkDailyReset();

    final bool exceeded = usedMinutes >= (dailyLimit + bonusMinutes);

    if (exceeded) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final modo = await _getModoBloqueio();
        if (modo == ModoBloqueio.pago.toString()) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => PenaltyScreen(
                onPaid: () async {
                  final prefs = await SharedPreferences.getInstance();
                  const int extraTime = 30;
                  final int currentLimit = prefs.getInt('dailyLimit') ?? 60;
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
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: popularApps.map((app) {
                final bool isSelected = selectedApps.contains(app.nome);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedApps.remove(app.nome);
                      } else {
                        selectedApps.add(app.nome);
                      }
                      _saveSelectedApps();
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        app.icone,
                        size: 40,
                        color: isSelected ? Colors.red : Colors.grey,
                      ),
                      const SizedBox(height: 4),
                      Text(app.nome, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            Text(
              'Tempo usado hoje: $usedMinutes minutos',
              style: TextStyle(
                fontSize: 18,
                color: exceeded ? Colors.red : Colors.black,
                fontWeight: exceeded ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const Text(
              'Bônus acumulado: ',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            Text(
              '$bonusMinutes minutos',
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _incrementUsedMinutes,
              child: const Text('Simular +5 minutos de uso'),
            ),
            const SizedBox(height: 30),
            const Divider(),
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
