import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
// import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos/daos.dart';
import 'tables/tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Cliente,
    ItemServicio,
    OrdenServicio,
    ItemServicioOrden,
    ConfiguracionEmpresa,
    Direccion,
    SizesRopa,
    CategoriaServicio,
    PreciosConceptos,
  ],
  daos: [
    ClientesDao,
    ItemServicioDao,
    OrdenServicioDao,
    ItemServicioOrdenDao,
    ConfiguracionEmpresaDao,
    DireccionDao,
    SizesRopaDao,
    CategoriaServicioDao,
    PreciosConceptosDao,
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
    return NativeDatabase(file);
  });
}
