import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import './../../core/database/app_database.dart';
import './../../core/database/daos/cliente_dao.dart';
import './../../core/database/daos/item_orden_dao.dart';
import './../../core/database/daos/item_servicio_dao.dart';
import './../../core/database/daos/orden_servicio_dao.dart';
import './../../core/database/daos/configuracion_empresa_dao.dart';
import './../../core/database/daos/direccion_dao.dart';
import 'injector.config.dart';

final instance = GetIt.instance;

@InjectableInit()
void configureDependencies() => instance.init();

@module
abstract class DatabaseModule {
  @lazySingleton
  AppDatabase get database => AppDatabase();

  @lazySingleton
  ClientesDao clienteDao(AppDatabase db) => db.clientesDao;
  @lazySingleton
  ItemsServicioDao itemServicioDao(AppDatabase db) => db.itemsServicioDao;
  @lazySingleton
  OrdenServicioDao ordenServicioDao(AppDatabase db) => db.ordenServicioDao;
  @lazySingleton
  ItemsOrdenServicioDao itemOrdenDao(AppDatabase db) => db.itemsOrdenServicioDao;
  @lazySingleton
  ConfiguracionEmpresaDao configuracionEmpresaDao(AppDatabase db) => db.configuracionEmpresaDao;
  @lazySingleton
  DireccionesDao direccionDao(AppDatabase db) => db.direccionesDao;
}