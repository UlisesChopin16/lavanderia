import 'package:flutter/material.dart';
import 'package:lavanderia/app/routes/app_routes.dart';
import 'package:lavanderia/core/utils/icons_manager.dart';
import 'package:lavanderia/features/catalogos/presentation/configuracion_general_view.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/views/configuracion_empresa_view.dart';
import 'package:lavanderia/features/orden_servicio/presentation/views/orden_servicio_view.dart';

enum HomeTabsType {
  empresas(
    title: 'Empresa',
    icon: IconsManager.selectedEmpresaIcon,
    unselectedIcon: IconsManager.unselectedEmpresaIcon,
    route: configuracionEmpresaR,
    // view: ConfiguracionEmpresaView(),
  ),
  ordenServicio(
    title: 'Ordenes servicio',
    icon: IconsManager.selectedOrdenServicioIcon,
    unselectedIcon: IconsManager.unselectedOrdenServicioIcon,
    route: ordenServicioR,
    // view: OrdenServicioView(),
  ),
  configuracionGeneral(
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
  view: ConfiguracionGeneralView(),
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
