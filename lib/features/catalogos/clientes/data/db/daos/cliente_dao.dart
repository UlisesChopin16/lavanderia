import 'package:drift/drift.dart';
import 'package:lavanderia/core/error/s_q_l_exception.dart';
import 'package:lavanderia/features/catalogos/clientes/data/db/cliente.dart';
import 'package:lavanderia/features/catalogos/clientes/domain/entities/filters/filtros_clientes.dart';

import '../../../../../../core/database/app_database.dart';

part 'cliente_dao.g.dart';

@DriftAccessor(tables: [Cliente])
class ClientesDao extends DatabaseAccessor<AppDatabase> with _$ClientesDaoMixin {
  ClientesDao(super.db);

  Future<List<ClienteEntry>> getAll() async => await select(cliente).get();

  Stream<List<ClienteEntry>> watchAll(FiltrosClientes filtros) {
    final query = select(cliente);
    if (filtros.nombre.isNotEmpty) {
      query.where(
        (tbl) =>
            tbl.nombres.like('%${filtros.nombre}%') |
            tbl.apellidos.like('%${filtros.nombre}%') |
            tbl.correo.like('%${filtros.nombre}%') |
            tbl.telefono.like('%${filtros.nombre}%'),
      );
    }

    final mode = filtros.ascendente ? OrderingMode.asc : OrderingMode.desc;

    query.orderBy([
      // if (filtros.estatus == EstatusType.todos && filtros.ordenamiento == null) ...orderAll,
      if (filtros.ordenamiento == ColumnClientesName.id)
        (tbl) => OrderingTerm(
          expression: tbl.id,
          mode: mode,
        ),
      if (filtros.ordenamiento == ColumnClientesName.nombre)
        (tbl) => OrderingTerm(
          expression: tbl.nombres,
          mode: mode,
        ),
      if (filtros.ordenamiento == ColumnClientesName.apellido)
        (tbl) => OrderingTerm(
          expression: tbl.apellidos,
          mode: mode,
        ),
      if (filtros.ordenamiento == ColumnClientesName.telefono)
        (tbl) => OrderingTerm(
          expression: tbl.telefono,
          mode: mode,
        ),
      if (filtros.ordenamiento == ColumnClientesName.correo)
        (tbl) => OrderingTerm(
          expression: tbl.correo,
          mode: mode,
        ),
      if (filtros.ordenamiento == ColumnClientesName.fechaCreacion)
        (tbl) => OrderingTerm(
          expression: tbl.fechaCreacion,
          mode: mode,
        ),
    ]);
    return query.watch();
  }

  // Future<ClienteEntry?> getById(int id) =>
  //     (select(cliente)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  // Obtener un cliente por ID o nombre
  Future<ClienteEntry?> getById(int id) async =>
      await (select(cliente)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<List<ClienteEntry>> getClientesByInfo(String info) async =>
      await (select(cliente)..where(
            (tbl) =>
                tbl.nombres.like('%$info%') |
                tbl.apellidos.like('%$info%') |
                tbl.correo.like('%$info%') |
                tbl.telefono.like('%$info%'),
          ))
          .get();

  Future<int> insertCliente(ClienteCompanion row) async {
    await rowExists(row);
    final now = DateTime.now();
    final clienteWithDate = row.copyWith(
      fechaCreacion: Value(now),
      fechaActualizacion: Value(now),
    );

    return await into(cliente).insert(clienteWithDate);
  }

  Future<bool> updateCliente(ClienteEntry row) async {
    await rowEntryExists(row);
    // Ensure that the cliente has an update date
    final now = DateTime.now();
    final clienteWithDate = row.copyWith(fechaActualizacion: Value(now));

    return await update(cliente).replace(clienteWithDate);
  }

  Future<void> rowExists(ClienteCompanion row) async {
    final query = select(cliente);
    // Nos aseguramos que el precio no exista ya en la base de datos con el mismo concepto
    // y el mismo tamaño
    query.where(
      (tbl) =>
          tbl.correo.equals(row.correo.value) |
          tbl.telefono.lower().equals(row.telefono.value.toLowerCase()),
    );

    final dataRow = await query.get();

    if (dataRow.isNotEmpty) {
      throw const SQLException(
        message: 'Ya hay un cliente en la base de datos con los mismos datos.',
      );
    }
  }

  Future<void> rowEntryExists(ClienteEntry row) async {
    final query = select(cliente);
    // Nos aseguramos que el precio no exista ya en la base de datos con el mismo concepto
    // y el mismo tamaño
    query.where(
      (tbl) =>
          (tbl.correo.lower().equals(row.correo.toLowerCase()) |
              tbl.telefono.lower().equals(row.telefono.toLowerCase())) &
          tbl.id.isNotIn([row.id]),
    );

    final dataRow = await query.get();

    if (dataRow.isNotEmpty) {
      throw const SQLException(
        message: 'Ya hay un cliente en la base de datos con los mismos datos.',
      );
    }
  }
}
