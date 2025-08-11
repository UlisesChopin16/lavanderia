import 'package:lavanderia/features/configuracion_empresa/data/datasources/configuracion_empresa_datasource.dart';
import 'package:lavanderia/features/configuracion_empresa/domain/entities/configuracion_empresa_entity.dart';
import 'package:lavanderia/features/configuracion_empresa/domain/extensions/configuracion_empresa_ext.dart';
import 'package:lavanderia/features/configuracion_empresa/domain/repositories/configuracion_empresa_repository.dart';

class ConfiguracionEmpresaRepoImpl implements ConfiguracionEmpresaRepository {
  final ConfiguracionEmpresaDatasource datasource;
  const ConfiguracionEmpresaRepoImpl({required this.datasource});

  @override
  Future<void> createConfiguracionEmpresa(ConfiguracionEmpresaEntity entity) async {
    // Convert the entity to a model and call the datasource method
    final model = entity.toModel();
    final entry = model.toEntry();
    final direccionModelo = entity.toModelDireccion();

    final idEmpresa = await datasource.saveConfiguracionEmpresa(entry);
    await datasource.saveDireccion(direccionModelo.copyWith(empresaId: idEmpresa).toEntry());
    // return await datasource.createConfiguracionEmpresa(entity.toModel());
  }

  @override
  Future<ConfiguracionEmpresaEntity?> getConfiguracionEmpresaById(int id) async {
    final empresaModel = await datasource.getConfiguracionEmpresaById(id);
    final direccionModel = await datasource.getDireccionById(id);

    if (empresaModel != null && direccionModel != null) {
      return ConfiguracionEmpresaEntity.fromModel(empresaModel, direccionModel);
      // return entry.toEntity(direccionEntry.toModel());
    }
    return null;
  }

  @override
  Future<void> updateConfiguracionEmpresa(ConfiguracionEmpresaEntity entry) async {
    // Convert the entity to a model and call the datasource method
    final model = entry.toModel();
    final direccionModel = entry.toModelDireccion();

    await datasource.updateConfiguracionEmpresa(model.toEntry());
    await datasource.updateDireccion(direccionModel.toEntry());
    // return await datasource.updateConfiguracionEmpresa(entry.toModel());
    
  }
  
}