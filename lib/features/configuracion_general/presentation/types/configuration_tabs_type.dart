import 'package:flutter/material.dart';
import 'package:lavanderia/features/configuracion_general/categorias/presentation/views/categorias_view.dart';
import 'package:lavanderia/features/configuracion_general/sizes/presentation/views/sizes_view.dart';

enum ConfigurationTabsType {
  categorias(
    title: 'Categorias de ropa',
    icon: Icons.category_rounded,
    unselectedIcon: Icons.category_outlined,
    view: CategoriasView(),
  ),
  sizes(
    title: 'Tamaños de ropa',
    icon: Icons.design_services_rounded,
    unselectedIcon: Icons.design_services_outlined,
    view: SizesView(),
  ),
  precios(
    title: 'Precios de ropa',
    icon: Icons.paid_rounded,
    unselectedIcon: Icons.paid_outlined,
    view: Center(child: Text('Precios de ropa')),
  );

  final String title;
  final IconData icon;
  final IconData unselectedIcon;
  final Widget view;

  const ConfigurationTabsType({
    required this.title,
    required this.icon,
    required this.unselectedIcon,
    required this.view,
  });
}
