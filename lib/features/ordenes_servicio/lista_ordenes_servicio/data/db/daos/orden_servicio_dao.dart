import 'package:drift/drift.dart';
import 'package:lavanderia/core/error/s_q_l_exception.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/data/db/orden_servicio.dart';

import '../../../../../../core/database/app_database.dart';

part 'orden_servicio_dao.g.dart';

@DriftAccessor(tables: [OrdenServicio])
class OrdenServicioDao extends DatabaseAccessor<AppDatabase> with _$OrdenServicioDaoMixin {
  OrdenServicioDao(super.db);

  // Future<List<OrdenServicioEntry>> getAll() => select(ordenServicio).get();

  // Stream<List<OrdenServicioEntry>> watchAll() => select(ordenServicio).watch();

  Future<OrdenServicioEntry?> getById(int id) async => await (select(
    ordenServicio,
  )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  // Future<List<OrdenServicioEntry>> getOrdenesForCliente(int clienteId) => (select(
  //   ordenServicio,
  // )..where((tbl) => tbl.clienteId.equals(clienteId))).get();

  Future<OrdenServicioEntry> insertOrden(OrdenServicioCompanion row) async {
    final now = DateTime.now();
    final folio = await generarNuevoFolio();

    final data = row.copyWith(
      fechaCreacion: Value(now),
      folio: Value(folio),
    );

    final id = await into(ordenServicio).insert(data);

    final entry = await getById(id);
    if (entry == null) {
      throw const SQLException(message: 'Error al insertar la orden de servicio');
    }

    return entry;
  }

  Future<bool> updateOrden(OrdenServicioEntry row) async {
    return update(ordenServicio).replace(row);
  }

  // Future<bool> updateOrden(Insertable<OrdenServicioEntry> row) {
  //   final now = DateTime.now();
  //   final casted = row as OrdenServicioEntry;
  //   return update(ordenServicio).replace(data);
  // }

  Future<String> generarNuevoFolio() async {
    final now = DateTime.now();
    final year = now.year.toString();
    final month = now.month.toString().padLeft(2, '0');

    // Consultamos el último folio del mes actual
    final ultimo =
        await (select(ordenServicio)
              ..where(
                (tbl) =>
                    tbl.fechaCreacion.year.equals(now.year) &
                    tbl.fechaCreacion.month.equals(now.month),
              )
              ..orderBy([(t) => OrderingTerm.desc(t.id)])
              ..limit(1))
            .getSingleOrNull();

    int consecutivo = 1;

    if (ultimo != null) {
      // El folio tiene formato AAAA-MM-XXXX
      final partes = ultimo.folio.toString().split('-');
      if (partes.length == 3) {
        final ultimoConsecutivo = int.tryParse(partes[2]) ?? 0;
        consecutivo = ultimoConsecutivo + 1;
      }
    }

    final consecutivoStr = consecutivo.toString().padLeft(4, '0');
    return "$year-$month-$consecutivoStr";
  }
}
