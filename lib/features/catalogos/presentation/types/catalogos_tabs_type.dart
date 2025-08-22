import 'package:flutter/material.dart';
import 'package:lavanderia/core/utils/icons_manager.dart';
import 'package:lavanderia/features/catalogos/categorias_sizes/presentation/categorias_sizes_view.dart';

enum CatalogosTabsType {
  categorias(
    title: 'Categorias y tamaños',
    icon: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      spacing: 10,
      children: [
        Icon(IconsManager.selectedCategoriasIcon),
        Icon(IconsManager.selectedSizesIcon),
      ],
    ),
    unselectedIcon: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      spacing: 10,
      children: [
        Icon(IconsManager.unselectedCategoriasIcon),
        Icon(IconsManager.unselectedSizesIcon),
      ],
    ),
    view: CategoriasSizesView(),
  ),
  precios(
    title: 'Precios de ropa',
    icon: Icon(IconsManager.selectedPreciosIcon),
    unselectedIcon: Icon(IconsManager.unselectedPreciosIcon),
    view: Center(child: Text('Precios de ropa')),
  );

// sizes(
//     title: 'Tamaños de ropa',
//     icon: IconsManager.selectedSizesIcon,
//     unselectedIcon: IconsManager.unselectedSizesIcon,
//     view: SizesView(),
//   ),
  final String title;
  final Widget icon;
  final Widget unselectedIcon;
  final Widget view;

  const CatalogosTabsType({
    required this.title,
    required this.icon,
    required this.unselectedIcon,
    required this.view,
  });
}
