import 'package:flutter/material.dart';
import 'package:lavanderia/core/utils/icons_manager.dart';
import 'package:lavanderia/features/catalogos/categorias_sizes/categorias/presentation/views/categorias_view.dart';
import 'package:lavanderia/features/catalogos/categorias_sizes/sizes/presentation/views/sizes_view.dart';

enum CatalogosTabsType {
  categorias(
    title: 'Categorias de ropa',
    icon: IconsManager.selectedCategoriasIcon,
    unselectedIcon: IconsManager.unselectedCategoriasIcon,
    view: CategoriasView(),
  ),
  sizes(
    title: 'Tamaños de ropa',
    icon: IconsManager.selectedSizesIcon,
    unselectedIcon: IconsManager.unselectedSizesIcon,
    view: SizesView(),
  ),
  precios(
    title: 'Precios de ropa',
    icon: IconsManager.selectedPreciosIcon,
    unselectedIcon: IconsManager.unselectedPreciosIcon,
    view: Center(child: Text('Precios de ropa')),
  );

  final String title;
  final IconData icon;
  final IconData unselectedIcon;
  final Widget view;

  const CatalogosTabsType({
    required this.title,
    required this.icon,
    required this.unselectedIcon,
    required this.view,
  });
}
