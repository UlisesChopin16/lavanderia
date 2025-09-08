import 'package:flutter/material.dart';

enum EstatusOrdenType {
  enCurso(
    value: "En curso",
    icon: Icons.pending_actions_rounded,
  ),
  cerrada(
    value: "Cerrada",
    icon: Icons.assignment_turned_in_rounded,
  ),
  cancelada(
    value: "Cancelada",
    icon: Icons.remove_circle_outline_rounded,
  );

  const EstatusOrdenType({
    required this.value,
    required this.icon,
  });

  final String value;
  final IconData icon;
}
