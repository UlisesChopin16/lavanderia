import 'package:flutter/material.dart';
import 'package:lavanderia/core/utils/icons_manager.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/views/configuracion_empresa_view.dart';

enum HomeTabsType {
  empresas(
    title: 'Configuración de empresa',
    icon: IconsManager.selectedEmpresaIcon,
    unselectedIcon: IconsManager.unselectedEmpresaIcon,
    view: ConfiguracionEmpresaView(),
  );

  final String title;
  final IconData icon;
  final IconData unselectedIcon;
  final Widget view;
  const HomeTabsType({
    required this.title,
    required this.icon,
    required this.unselectedIcon,
    required this.view,
  });
}
