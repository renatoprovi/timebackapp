import 'package:flutter/material.dart';
import '../models/app_info.dart';

/// Widget que exibe uma grade (grid) de aplicativos para seleção.
///
/// Recebe uma lista de [AppInfo], um conjunto de nomes de apps selecionados
/// e uma função callback que é chamada ao alternar a seleção de um app.
class AppSelectorGrid extends StatelessWidget {
  /// Lista de aplicativos para exibição.
  final List<AppInfo> apps;

  /// Conjunto de nomes dos aplicativos atualmente selecionados.
  final Set<String> selectedApps;

  /// Callback chamado ao alternar a seleção de um aplicativo.
  /// Recebe o nome do aplicativo como argumento.
  final Function(String) onToggle;

  /// Construtor do widget, exige todos os parâmetros.
  const AppSelectorGrid({
    super.key,
    required this.apps,
    required this.selectedApps,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: apps.map((app) {
        final isSelected = selectedApps.contains(app.nome);
        return GestureDetector(
          onTap: () => onToggle(app.nome),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                app.icone,
                color: isSelected ? Colors.red : Colors.grey,
                size: 40,
              ),
              Text(
                app.nome,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

