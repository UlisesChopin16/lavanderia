import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:lavanderia/core/utils/printer.dart';
// import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos/daos.dart';
import 'tables/tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Cliente,
    OrdenServicio,
    ItemServicioOrden,
    ConfiguracionEmpresa,
    Direccion,
    SizesRopa,
    CategoriaServicio,
    PreciosConceptos,
    OrdenHistory,
  ],
  daos: [
    ClientesDao,
    OrdenServicioDao,
    ItemServicioOrdenDao,
    ConfiguracionEmpresaDao,
    DireccionDao,
    SizesRopaDao,
    CategoriaServicioDao,
    PreciosConceptosDao,
    OrdenHistoryDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  // AppDatabase.defaults()
  //     : super(
  //         driftDatabase(
  //           name: 'app_db',
  //           native: const DriftNativeOptions(
  //             shareAcrossIsolates: true,

  //           ),
  //         ),
  //       );

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'app.db'));
    Printer.i('Database file path: ${file.path}');
    return NativeDatabase(file);
  });
}
