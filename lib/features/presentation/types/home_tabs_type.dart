import 'package:flutter/material.dart';
import 'package:lavanderia/app/routes/app_routes.dart';
import 'package:lavanderia/core/utils/icons_manager.dart';
import 'package:lavanderia/features/catalogos/presentation/views/catalogos_view.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/views/configuracion_empresa_view.dart';
import 'package:lavanderia/features/ordenes_servicio/presentation/views/home_ordenes_view.dart';

enum HomeTabsType {
  ordenServicio(
    title: 'Ordenes servicio',
    icon: IconsManager.selectedOrdenServicioIcon,
    unselectedIcon: IconsManager.unselectedOrdenServicioIcon,
    route: ordenServicioR,
    // view: OrdenServicioView(),
  ),
  catalogos(
    title: 'Catalogos',
    icon: IconsManager.selectedCatalogoIcon,
    unselectedIcon: IconsManager.unselectedCatalogoIcon,
    route: configuracionGeneralR,
  ),
  clientes(
    title: 'Clientes',
    icon: IconsManager.selectedClientesIcon,
    unselectedIcon: IconsManager.unselectedClientesIcon,
    route: clientesR,
  ),
  empresas(
    title: 'Empresa',
    icon: IconsManager.selectedEmpresaIcon,
    unselectedIcon: IconsManager.unselectedEmpresaIcon,
    route: configuracionEmpresaR,
    // view: ConfiguracionEmpresaView(),
  );

  final String title;
  final IconData icon;
  final IconData unselectedIcon;
  final DataRoute route;
  const HomeTabsType({
    required this.title,
    required this.icon,
    required this.unselectedIcon,
    required this.route,
  });
}

const DataRoute configuracionEmpresaR = DataRoute(
  path: AppRoutes.configuracionEmpresa,
  name: 'ConfiguracionEmpresa',
  view: ConfiguracionEmpresaView(),
);
const DataRoute ordenServicioR = DataRoute(
  path: AppRoutes.ordenServicio,
  name: 'OrdenServicio',
  view: OrdenServicioView(),
);
const DataRoute configuracionGeneralR = DataRoute(
  path: AppRoutes.catalogos,
  name: 'ConfiguracionGeneral',
  view: CatalogosView(),
);
const DataRoute clientesR = DataRoute(
  path: AppRoutes.clientes,
  name: 'Clientes',
  view: Scaffold(
    body: Center(
      child: Text('Clientes'),
    ),
  ),
);
