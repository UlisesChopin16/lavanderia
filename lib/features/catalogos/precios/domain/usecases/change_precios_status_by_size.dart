import 'package:injectable/injectable.dart';
import 'package:lavanderia/features/catalogos/precios/domain/repositories/precios_change_repository.dart';

@lazySingleton
class ChangePreciosStatusBySize {
  final PreciosChangeRepository repository;

  ChangePreciosStatusBySize(this.repository);

  Future<void> activatePrecios(int sizeId) async {
    await repository.activatePreciosBySize(sizeId);
  }

  Future<void> deactivatePrecios(int sizeId) async {
    await repository.deactivatePreciosBySize(sizeId);
  }
}