import 'package:drift/drift.dart';
import 'orden_servicio.dart';
@DataClassName('OrdenHistoryEntry')
class OrdenHistory extends Table {
  IntColumn get id => integer().autoIncrement()();  
  IntColumn get ordenId => integer().references(OrdenServicio, #id)();  
  RealColumn get monto => real()();  
  TextColumn get metodoPago => text()(); // "Efectivo", "Tarjeta", "Transferencia"
  DateTimeColumn get fecha => dateTime()();  
}