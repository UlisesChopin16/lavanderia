import 'package:flutter/material.dart';

enum EstatusOrdenType {
  todos(value: "Todos", icon: Icons.list_rounded, color: Colors.blue),
  enCurso(
    value: "En curso",
    icon: Icons.pending_actions_rounded,
    color: Colors.orange,
  ),
  pagado(
    value: "Pagado",
    icon: Icons.attach_money_rounded,
    color: Colors.lightGreen,
  ),
  cerrada(
    value: "Cerrada",
    icon: Icons.assignment_turned_in_rounded,
    color: Colors.green,
  ),
  cancelada(
    value: "Cancelada",
    icon: Icons.remove_circle_outline_rounded,
    color: Colors.grey,
  )
  ;

  const EstatusOrdenType({
    required this.value,
    required this.icon,
    required this.color,
  });

  final String value;
  final IconData icon;
  final Color color;

  static EstatusOrdenType fromString(String value) {
    return EstatusOrdenType.values.firstWhere(
      (element) => element.value == value,
      orElse: () => EstatusOrdenType.enCurso,
    );
  }
}
