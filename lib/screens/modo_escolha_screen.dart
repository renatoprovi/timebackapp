import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/modo_bloqueio.dart';
import 'home_screen.dart';

/// Tela para o usuário escolher o modo de bloqueio.
///
/// Pode escolher entre força de vontade (sem volta) ou modo pago,
/// onde define valor da penalidade para continuar.
class ModoEscolhaScreen extends StatefulWidget {
  const ModoEscolhaScreen({super.key});

  @override
  State<ModoEscolhaScreen> createState() => _ModoEscolhaScreenState();
}

class _ModoEscolhaScreenState extends State<ModoEscolhaScreen> {
  ModoBloqueio? _modoSelecionado;
  double _valorPenalidade = 5.0;

  /// Salva o modo selecionado e, se for pago, também o valor da penalidade.
  ///
  /// Após salvar, navega para a tela principal.
  Future<void> _salvarModo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('modoBloqueio', _modoSelecionado.toString());
    if (_modoSelecionado == ModoBloqueio.pago) {
      await prefs.setDouble('valorPenalidade', _valorPenalidade);
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escolha o Modo')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Como você quer ser bloqueado?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            RadioListTile<ModoBloqueio>(
              title: const Text('Modo Força de Vontade (sem volta)'),
              value: ModoBloqueio.forcaDeVontade,
              groupValue: _modoSelecionado,
              onChanged: (value) {
                setState(() {
                  _modoSelecionado = value;
                });
              },
            ),
            RadioListTile<ModoBloqueio>(
              title: const Text('Modo Pago (pague para continuar)'),
              value: ModoBloqueio.pago,
              groupValue: _modoSelecionado,
              onChanged: (value) {
                setState(() {
                  _modoSelecionado = value;
                });
              },
            ),
            if (_modoSelecionado == ModoBloqueio.pago) ...[
              const SizedBox(height: 20),
              const Text('Defina o valor da penalidade:'),
              Slider(
                value: _valorPenalidade,
                min: 1,
                max: 50,
                divisions: 49,
                label: 'R\$ ${_valorPenalidade.toStringAsFixed(2)}',
                onChanged: (value) {
                  setState(() {
                    _valorPenalidade = value;
                  });
                },
              ),
            ],
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _modoSelecionado != null ? _salvarModo : null,
              child: const Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}
