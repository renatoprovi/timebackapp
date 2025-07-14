import 'package:flutter/material.dart';

/// Classe que representa informações básicas de um aplicativo.
///
/// Contém o nome e o ícone associado ao app.
class AppInfo {
  /// Nome do aplicativo.
  final String nome;

  /// Ícone que representa o aplicativo.
  final IconData icone;

  /// Construtor obrigatório para inicializar nome e ícone.
  AppInfo({
    required this.nome,
    required this.icone,
  });
}

