import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/core/types/estatus_type.dart';
import 'package:lavanderia/features/catalogos/precios/domain/types/unit_type.dart';
export 'package:lavanderia/core/types/estatus_type.dart';
export 'package:lavanderia/features/catalogos/precios/domain/types/unit_type.dart';

part 'precio_con_detalles_entity.freezed.dart';
part 'precio_con_detalles_entity.g.dart';

@freezed
sealed class PrecioConDetallesEntity with _$PrecioConDetallesEntity {
  const factory PrecioConDetallesEntity({
    @Default(-1) int idPrecio,
    @Default(-1) int idSize,
    @Default(-1) int idCategoria,
    @Default('') String nombreConcepto,
    @Default('') String nombreCategoria,
    @Default('') String nombreSize,
    @Default(0) int diasEntrega,
    @Default(UnitType.pieza) UnitType tipoUnidad,
    @Default(0.0) double importe,
    @Default(EstatusType.inactivo) EstatusType estatus,
    @Default(null) DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
    DateTime? fechaEliminacion,
  }) = _PrecioConDetallesEntity;

  factory PrecioConDetallesEntity.fromJson(Map<String, dynamic> json) => _$PrecioConDetallesEntityFromJson(json);
}

// class PreciosConceptos extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   IntColumn get categoriaId => integer().references(CategoriaServicio, #id)();
//   IntColumn get sizeRopaId => integer().references(SizesRopa, #id)();
//   TextColumn get nombreConcepto => text()();
//   IntColumn get diasEntrega => integer()(); // Días de entrega para este item en esta categoría
//   TextColumn get tipoUnidad => text()(); // Ej. "Kg" o "pieza"
//   RealColumn get importe => real()();
//   TextColumn get estatus => text()(); // Ej. "Activo", "Inactivo"
//   DateTimeColumn get fechaCreacion => dateTime()();
//   DateTimeColumn get fechaActualizacion => dateTime().nullable()();
//   DateTimeColumn get fechaEliminacion => dateTime().nullable()();
// }