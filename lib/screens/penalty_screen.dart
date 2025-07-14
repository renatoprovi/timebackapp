import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/home_screen.dart';

/// Tela de penalidade exibida quando o usuário ultrapassa o limite diário.
///
/// Solicita contribuição voluntária para liberar tempo extra.
class PenaltyScreen extends StatelessWidget {
  /// Função callback chamada quando o usuário realiza o pagamento da penalidade.
  final Future<void> Function() onPaid;

  const PenaltyScreen({super.key, required this.onPaid});

  /// Obtém o valor da penalidade salvo nas preferências, ou retorna padrão 5.0.
  Future<double> _getPenaltyAmount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('valorPenalidade') ?? 5.0;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
      future: _getPenaltyAmount(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final penaltyAmount = snapshot.data!;

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
                        content:
                            Text('Penalidade paga. +30 minutos adicionados!'),
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
      },
    );
  }
}

