import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/core/error/validate_exception.dart';
import 'package:lavanderia/core/types/estatus_type.dart';

part 'categoria_servicio_entity.freezed.dart';

@freezed
sealed class CategoriaServicioEntity with _$CategoriaServicioEntity {
  const CategoriaServicioEntity._();

  const factory CategoriaServicioEntity({
    @Default(-1) int id,
    @Default('') String nombre,
    @Default(EstatusType.activo) EstatusType estatus,
    @Default(1) int diasEntrega,
    @Default(null) DateTime? fechaCreacion,
    @Default(null) DateTime? fechaActualizacion,
    @Default(null) DateTime? fechaEliminacion,
  }) = _CategoriaServicioEntity;

  bool get isInactive => estatus == EstatusType.inactivo;

  void validate() {
    final errors = <String>[];

    if (nombre.isEmpty) {
      errors.add(' - El nombre de la categoría no puede estar vacío.');
    }
    if (diasEntrega < 1) {
      errors.add(' - Los días de entrega deben ser al menos 1.');
    }
    if (errors.isNotEmpty) {
      final unionError = errors.join('\n');
      throw ValidateException(message: unionError);
    }

  }
}

// required int id,
    // required String nombre,
    // required String estatus,
    // required DateTime fechaCreacion,
    // DateTime? fechaActualizacion,
    // DateTime? fechaEliminacion,