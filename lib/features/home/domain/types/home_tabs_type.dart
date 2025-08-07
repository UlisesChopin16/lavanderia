import 'package:flutter/material.dart';
import 'package:lavanderia/app/routes/app_routes.dart';
import 'package:lavanderia/core/utils/icons_manager.dart';

enum HomeTabsType {
  empresas(
    title: 'Empresa',
    icon: IconsManager.selectedEmpresaIcon,
    unselectedIcon: IconsManager.unselectedEmpresaIcon,
    route: AppRoutes.configuracionEmpresa,
    // view: ConfiguracionEmpresaView(),
  ),
  ordenServicio(
    title: 'Orden de Servicio',
    icon: IconsManager.selectedOrdenServicioIcon,
    unselectedIcon: IconsManager.unselectedOrdenServicioIcon,
    route: AppRoutes.home,
    // view: OrdenServicioView(),
  );

  final String title;
  final IconData icon;
  final IconData unselectedIcon;
  // final Widget view;
  final String route;
  const HomeTabsType({
    required this.title,
    required this.icon,
    required this.unselectedIcon,
    // required this.view,
    required this.route,
  });
}
