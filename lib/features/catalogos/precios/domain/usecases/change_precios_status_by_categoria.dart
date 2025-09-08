
import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/catalogos/categorias/domain/entities/categoria_servicio_entity.dart';
import 'package:lavanderia/features/catalogos/precios/domain/repositories/precios_change_repository.dart';

@lazySingleton
class ChangePreciosStatusByCategoria {
  final PreciosChangeRepository repository;

  ChangePreciosStatusByCategoria(this.repository);

  Future<void> activatePrecios(int categoriaId) async {
    await repository.activatePreciosByCategoria(categoriaId);
  }

  Future<void> deactivatePrecios(int categoriaId) async {
    await repository.deactivatePreciosByCategoria(categoriaId);
  }

  Future<void> changeDiasPrecios(CategoriaServicioEntity categoria) async {
    await repository.changeDiasPreciosByCategoria(categoria);
  }
}