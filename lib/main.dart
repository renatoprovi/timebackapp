import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const TimeBackApp());
}

class TimeBackApp extends StatelessWidget {
  const TimeBackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TimeBack',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int dailyLimit = 60;
  int usedMinutes = 0;
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

  Future<void> _saveSelectedApps() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('selectedApps', selectedApps.toList());
  }

  void _incrementUsedMinutes() {
    setState(() {
      usedMinutes += 5;
    });
    _saveUsedMinutes();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    bool exceeded = usedMinutes >= dailyLimit;

    if (exceeded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => PenaltyScreen(
              onPaid: () async {
                final prefs = await SharedPreferences.getInstance();
                int extraTime = 30;
                int currentLimit = prefs.getInt('dailyLimit') ?? 60;
                int newLimit = currentLimit + extraTime;
                await prefs.setInt('dailyLimit', newLimit);
              },
            ),
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('TimeBack'),
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
                      content:
                          Text('Limite diário salvo: $dailyLimit minutos'),
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _incrementUsedMinutes,
              child: const Text('Simular +5 minutos de uso'),
            ),
          ],
        ),
      ),
    );
  }
}

class PenaltyScreen extends StatelessWidget {
  final Future<void> Function() onPaid;
  const PenaltyScreen({super.key, required this.onPaid});

  @override
  Widget build(BuildContext context) {
    const penaltyAmount = 5.00;

    return Scaffold(
      appBar: AppBar(title: const Text('Penalidade')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Você ultrapassou seu limite diário!\n\n'
              'Para continuar, contribua voluntariamente com\n'
              'R\$${penaltyAmount.toStringAsFixed(2)}\n\n'
              'Ao pagar, você receberá +30 minutos extras de uso.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                await onPaid();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Penalidade paga. +30 minutos adicionados!'),
                  ),
                );

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              },
              child: const Text('Pagar Penalidade e Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}

