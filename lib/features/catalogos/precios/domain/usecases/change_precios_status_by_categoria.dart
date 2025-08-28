
import 'package:injectable/injectable.dart';
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
}