import 'package:flutter/material.dart';
import 'package:lavanderia/core/utils/icons_manager.dart';
import 'package:lavanderia/features/catalogos/categorias/presentation/views/categoria_view.dart';
import 'package:lavanderia/features/catalogos/clientes/presentation/views/clientes_view.dart';
import 'package:lavanderia/features/catalogos/precios/presentation/views/precios_view.dart';

enum CatalogosTabsType {
  clientes(
    title: 'Clientes',
    icon: IconsManager.selectedClientesIcon,
    unselectedIcon: IconsManager.unselectedClientesIcon,
    view: ClientesView(),
  ),
  categorias(
    title: 'Categorias de ropa',
    icon: IconsManager.selectedCategoriasIcon,
    unselectedIcon: IconsManager.unselectedCategoriasIcon,
    view: CategoriaView(),
  ),
  precios(
    title: 'Precios de ropa',
    icon: IconsManager.selectedPreciosIcon,
    unselectedIcon: IconsManager.unselectedPreciosIcon,
    view: PreciosView(),
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
