import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum OrdenTabType {
  crearOrden(
    title: 'Crear orden',
    icon: Icons.add_circle_rounded,
    unselectedIcon: Icons.add_circle_outline_rounded,
    view: Scaffold(body: Center(child: Text('Vista para crear una nueva orden'))),
  ),
  listaOrdenes(
    title: 'Lista de órdenes',
    icon: FontAwesomeIcons.listUl,
    unselectedIcon: FontAwesomeIcons.list,
    view: Scaffold(body: Center(child: Text('Vista para listar órdenes existentes'))),
  );

  final String title;
  final IconData icon;
  final IconData unselectedIcon;
  final Widget view;

  const OrdenTabType({
    required this.title,
    required this.icon,
    required this.unselectedIcon,
    required this.view,
  });
}
