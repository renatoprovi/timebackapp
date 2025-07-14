import 'package:flutter/material.dart';
import '../models/app_info.dart';

class AppSelectorGrid extends StatelessWidget {
  final List<AppInfo> apps;
  final Set<String> selectedApps;
  final Function(String) onToggle;

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
      physics: NeverScrollableScrollPhysics(),
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
              Text(app.nome, style: TextStyle(fontSize: 12)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
