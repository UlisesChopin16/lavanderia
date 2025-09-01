import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/core/extensions/string_ext.dart';
import 'package:lavanderia/core/types/estatus_type.dart';
import 'package:lavanderia/features/catalogos/categorias/domain/entities/categoria_servicio_entity.dart';
import 'package:lavanderia/features/catalogos/precios/domain/types/unit_type.dart';
import 'package:lavanderia/features/catalogos/sizes/domain/entities/sizes_ropa/size_ropa_entity.dart';

export 'package:lavanderia/core/types/estatus_type.dart';
export 'package:lavanderia/features/catalogos/precios/domain/types/unit_type.dart';

part 'precio_con_detalles_entity.freezed.dart';

@freezed
sealed class PrecioConDetallesEntity with _$PrecioConDetallesEntity {
  const PrecioConDetallesEntity._();

  const factory PrecioConDetallesEntity({
    @Default(-1) int idPrecio,
    @Default('') String nombreConcepto,
    @Default(CategoriaServicioEntity()) CategoriaServicioEntity categoria,
    @Default(SizesRopaEntity()) SizesRopaEntity size,
    @Default(0) int diasEntrega,
    @Default(UnitType.pieza) UnitType tipoUnidad,
    @Default(0.0) double importe,
    @Default(EstatusType.activo) EstatusType estatus,
    @Default(null) DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
    DateTime? fechaEliminacion,
  }) = _PrecioConDetallesEntity;

  String get errorMessage =>
      'El concepto "$nombreConcepto" ya existe en la categoría "${categoria.nombre}" y tamaño "${size.nombre}"';

  String get key => '$nombreConcepto-${categoria.id}-${size.id}';

  bool get isEmpty => nombreConcepto.isEmpty && categoria.id == -1 && size.id == -1 && importe == 0.0 && diasEntrega == 0;

  bool get hasCategoria => categoria.id != -1;
  bool get hasSize => size.id != -1;
  bool get hasImporte => importe != 0.0 && importe > 0.0;
  bool get hasName => nombreConcepto.normalizeSpaces().isNotEmpty;
  bool get hasDays => diasEntrega != 0 && diasEntrega > 0;
  bool get isActive => estatus == EstatusType.activo;

  String validate() {
    final errors = <String>[];

    if (!hasName) {
      errors.add(' - El nombre del concepto es obligatorio');
    }
    if (!hasCategoria) {
      errors.add(' - La categoría es obligatoria');
    }
    if (!hasSize) {
      errors.add(' - El tamaño es obligatorio');
    }
    if (!hasImporte) {
      errors.add(' - El importe es obligatorio');
    }
    if (!hasDays) {
      errors.add(' - Los días de entrega son obligatorios');
    }

    return errors.join('\n');
  }
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
