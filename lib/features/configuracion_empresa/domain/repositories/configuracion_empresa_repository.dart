import 'package:lavanderia/features/configuracion_empresa/domain/entities/configuracion_empresa_entity.dart';

abstract class ConfiguracionEmpresaRepository {
  // Define methods that the repository should implement
  Future<void> createConfiguracionEmpresa(ConfiguracionEmpresaEntity entry);
  Future<ConfiguracionEmpresaEntity?> getConfiguracionEmpresaById(int id);
  Future<void> updateConfiguracionEmpresa(ConfiguracionEmpresaEntity entry);
}
