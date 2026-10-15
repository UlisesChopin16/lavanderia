import 'package:lavanderia/models/data/configuracion_empresa/configuracion_empresa_entity.dart';

abstract class ConfiguracionEmpresaRepository {
  // Define methods that the repository should implement
  Future<void> createConfiguracionEmpresa(ConfiguracionEmpresaEntity entry);
  Future<ConfiguracionEmpresaEntity?> getConfiguracionEmpresaById(int id);
  Future<void> updateConfiguracionEmpresa(ConfiguracionEmpresaEntity entry);
}
