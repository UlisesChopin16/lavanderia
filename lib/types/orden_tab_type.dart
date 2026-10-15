import 'package:flutter/material.dart';
import 'package:lavanderia/ui/views/lista_ordenes/lista_ordenes_view.dart';
import 'package:lavanderia/ui/views/orden_servicio/orden_servicio_view.dart';

enum OrdenTabType {
  crearOrden(
    title: 'Crear orden',
    icon: Icons.add_circle_rounded,
    unselectedIcon: Icons.add_circle_outline_rounded,
    view: OrdenServicioView(),
  ),
  listaOrdenes(
    title: 'Lista de órdenes',
    icon: Icons.list_alt_rounded,
    unselectedIcon: Icons.list_alt_outlined,
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
