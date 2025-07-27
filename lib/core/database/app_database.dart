import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/tables.dart';

import 'daos/daos.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Clientes,
    ItemsServicio,
    OrdenesServicio,
    ItemsOrden,
    ConfiguracionEmpresa,
    Direcciones,
    EstatusUrgencia,
  ],
  daos: [
    ClientesDao,
    ItemsServicioDao,
    OrdenServicioDao,
    ItemsOrdenServicioDao,
    ConfiguracionEmpresaDao,
    DireccionesDao,
    EstatusUrgenciaDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'app.db'));
    return NativeDatabase(file);
  });
}
