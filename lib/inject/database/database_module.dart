import 'package:injectable/injectable.dart';
import 'package:lavanderia/data/local/app_database.dart';
import 'package:lavanderia/data/local/daos.dart';

/// Módulo de inyección de la base de datos local (drift).
/// Expone la instancia de [AppDatabase] y cada uno de sus DAOs.
@module
abstract class DatabaseModule {
  @lazySingleton
  AppDatabase get database => AppDatabase();

  @lazySingleton
  CategoriaServicioDao categoriaServicioDao(AppDatabase db) => db.categoriaServicioDao;
  @lazySingleton
  PreciosConceptosDao preciosConceptosDao(AppDatabase db) => db.preciosConceptosDao;
  @lazySingleton
  ClientesDao clienteDao(AppDatabase db) => db.clientesDao;
  @lazySingleton
  ConfiguracionEmpresaDao configuracionEmpresaDao(AppDatabase db) => db.configuracionEmpresaDao;
  @lazySingleton
  ItemServicioOrdenDao itemOrdenDao(AppDatabase db) => db.itemServicioOrdenDao;
  @lazySingleton
  DireccionDao direccionDao(AppDatabase db) => db.direccionDao;
  @lazySingleton
  OrdenServicioDao ordenServicioDao(AppDatabase db) => db.ordenServicioDao;
  @lazySingleton
  OrdenHistoryDao ordenHistoryDao(AppDatabase db) => db.ordenHistoryDao;
}
