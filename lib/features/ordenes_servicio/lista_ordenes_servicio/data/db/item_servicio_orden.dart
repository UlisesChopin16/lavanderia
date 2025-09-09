import 'package:drift/drift.dart';
import 'package:lavanderia/features/catalogos/precios/data/db/precios_conceptos.dart';
import 'orden_servicio.dart';

@DataClassName('ItemServicioOrdenEntry')
class ItemServicioOrden extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ordenId => integer().references(OrdenServicio, #id)();
  IntColumn get precioConceptoId => integer().references(PreciosConceptos, #id)();
  RealColumn get cantidad => real()();
  RealColumn get importe => real()();
  BoolColumn get estaEntregado => boolean().withDefault(const Constant(false))();
  DateTimeColumn get fechaEntrega => dateTime()();
  DateTimeColumn get fechaCreacion => dateTime()();
}