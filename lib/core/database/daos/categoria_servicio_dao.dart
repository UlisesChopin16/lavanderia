import 'package:drift/drift.dart';
import 'package:lavanderia/core/database/tables/categoria_servicio.dart';
import '../app_database.dart';

part 'categoria_servicio_dao.g.dart';

@DriftAccessor(tables: [CategoriaServicio])
class CategoriaServicioDao extends DatabaseAccessor<AppDatabase>
    with _$CategoriaServicioDaoMixin {
  CategoriaServicioDao(super.db);

  Future<List<CategoriaServicioEntry>> getAll() =>
      select(categoriaServicio).get();

  Stream<List<CategoriaServicioEntry>> watchAll() =>
      select(categoriaServicio).watch();

  Future<CategoriaServicioEntry?> getById(int id) =>
      (select(categoriaServicio)..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull();

  Future<int> insertCategoria(Insertable<CategoriaServicioEntry> row) {
    final now = DateTime.now();
    final casted = row as CategoriaServicioEntry;
    final data = casted.copyWith(
      fechaCreacion: now,
      fechaActualizacion: const Value(null),
    );
    return into(categoriaServicio).insert(data);
  }

  Future<bool> updateCategoria(Insertable<CategoriaServicioEntry> row) {
    final now = DateTime.now();
    final casted = row as CategoriaServicioEntry;
    final data = casted.copyWith(fechaActualizacion: Value(now));
    return update(categoriaServicio).replace(data);
  }

  Future<bool> deleteCategoria(int id) async {
    final now = DateTime.now();
    final record = await getById(id);
    if (record == null) return false;
    final updated = record.copyWith(fechaEliminacion: Value(now));
    return update(categoriaServicio).replace(updated);
  }
}