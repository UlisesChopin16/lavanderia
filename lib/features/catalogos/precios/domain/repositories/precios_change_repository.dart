abstract class PreciosChangeRepository {
  Future<void> activatePreciosBySize(int sizeId);
  Future<void> deactivatePreciosBySize(int sizeId);
  Future<void> activatePreciosByCategoria(int categoriaId);
  Future<void> deactivatePreciosByCategoria(int categoriaId);
}
