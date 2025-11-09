import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/core/types/clothe_size_type.dart';
import 'package:lavanderia/features/catalogos/categorias/data/models/categoria_servicio_model.dart';

part 'precio_con_detalles_model.freezed.dart';
part 'precio_con_detalles_model.g.dart';

@freezed
sealed class PrecioConDetallesModel with _$PrecioConDetallesModel {
  const factory PrecioConDetallesModel({
    required int idPrecio,
    required String nombreConcepto,
    @Default(ClotheSizeType.emptySize) ClotheSizeType size,
    required CategoriaServicioModel categoria,
    required int diasEntrega,
    required String tipoUnidad,
    required double importe,
    required String estatus,
    required DateTime fechaCreacion,
    DateTime? fechaActualizacion,
    DateTime? fechaEliminacion,
  }) = _PrecioConDetallesModel;

  factory PrecioConDetallesModel.fromJson(Map<String, dynamic> json) => _$PrecioConDetallesModelFromJson(json);
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