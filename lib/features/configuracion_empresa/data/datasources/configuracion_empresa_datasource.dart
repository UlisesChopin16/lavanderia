import 'package:injectable/injectable.dart';
import 'package:lavanderia/core/database/app_database.dart';
import 'package:lavanderia/core/database/daos/daos.dart';
import 'package:lavanderia/features/configuracion_empresa/data/models/configuracion_empresa_model.dart';

@lazySingleton
class ConfiguracionEmpresaDatasource {
  final ConfiguracionEmpresaDao configuracionEmpresaDao;
  final DireccionDao direccionDao;

  const ConfiguracionEmpresaDatasource({
    required this.configuracionEmpresaDao,
    required this.direccionDao,
  });

  Future<int> saveConfiguracionEmpresa(ConfiguracionEmpresaEntry entry) async =>
      await configuracionEmpresaDao.insertConfig(entry);

  Future<ConfiguracionEmpresaModel?> getConfiguracionEmpresaById(int id) async {
    final result = await configuracionEmpresaDao.getById(id);
    if (result != null) {
      return ConfiguracionEmpresaModel.fromEntry(result);
    }
    return null;
  }
  Future<void> updateConfiguracionEmpresa(ConfiguracionEmpresaEntry entry) async =>
      await configuracionEmpresaDao.updateConfig(entry);
  
  Future<DireccionModel?> getDireccionById(int id) async {
    final result = await direccionDao.getById(id);
    if (result != null) {
      return DireccionModel.fromEntry(result);
    }
    return null;
  }
  Future<int> saveDireccion(DireccionEntry entry) async =>
      await direccionDao.insertDireccion(entry);

  Future<void> updateDireccion(DireccionEntry entry) async =>
      await direccionDao.updateDireccion(entry);
}
