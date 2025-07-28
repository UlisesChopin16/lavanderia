import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import './../../core/database/app_database.dart';
import './../../core/database/daos/daos.dart';
import 'injector.config.dart';

final instance = GetIt.instance;

@InjectableInit()
void configureDependencies() => instance.init();

@module
abstract class DatabaseModule {
  @lazySingleton
  AppDatabase get database => AppDatabase();

  @lazySingleton
  CategoriaServicioDao categoriaServicioDao(AppDatabase db) => db.categoriaServicioDao;
  @lazySingleton
  CategoriaItemServicioDao categoriaItemServicioDao(AppDatabase db) => db.categoriaItemServicioDao;
  @lazySingleton
  ClientesDao clienteDao(AppDatabase db) => db.clientesDao;
  @lazySingleton
  ConfiguracionEmpresaDao configuracionEmpresaDao(AppDatabase db) => db.configuracionEmpresaDao;
  @lazySingleton
  EstatusUrgenciaDao estatusUrgenciaDao(AppDatabase db) => db.estatusUrgenciaDao;
  @lazySingleton
  ItemServicioDao itemServicioDao(AppDatabase db) => db.itemServicioDao;
  @lazySingleton
  ItemServicioOrdenDao itemOrdenDao(AppDatabase db) => db.itemServicioOrdenDao;
  @lazySingleton
  DireccionDao direccionDao(AppDatabase db) => db.direccionDao;
  @lazySingleton
  OrdenServicioDao ordenServicioDao(AppDatabase db) => db.ordenServicioDao;
}