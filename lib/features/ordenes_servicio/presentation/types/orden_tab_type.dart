import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/presentation/view/lista_ordenes_view.dart';
import 'package:lavanderia/features/ordenes_servicio/orden_servicio/presentation/view/orden_servicio_view.dart';

enum OrdenTabType {
  crearOrden(
    title: 'Crear orden',
    icon: Icons.add_circle_rounded,
    unselectedIcon: Icons.add_circle_outline_rounded,
    view: OrdenServicioView(),
  ),
  listaOrdenes(
    title: 'Lista de órdenes',
    icon: FontAwesomeIcons.listUl,
    unselectedIcon: FontAwesomeIcons.list,
    view: ListaOrdenesView(),
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
