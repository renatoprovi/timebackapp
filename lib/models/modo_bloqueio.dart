/// Enumeração que representa os modos de bloqueio do aplicativo.
///
/// - [forcaDeVontade]: Bloqueio sem possibilidade de volta (modo rigoroso).
/// - [pago]: Bloqueio que permite desbloquear mediante pagamento.
enum ModoBloqueio {
  /// Bloqueio com força de vontade, sem volta.
  forcaDeVontade,

  /// Bloqueio que exige pagamento para continuar.
  pago,
}
