import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../../../core/database/app_database.dart';

part 'categoria_servicio.freezed.dart';
part 'categoria_servicio.g.dart';

@freezed
sealed class CategoriaServicioModel with _$CategoriaServicioModel {
  const factory CategoriaServicioModel({
    required int id,
    required String nombre,
    required String estatus,
    required DateTime fechaCreacion,
    DateTime? fechaActualizacion,
    DateTime? fechaEliminacion,
  }) = _CategoriaServicioModel;

  factory CategoriaServicioModel.fromJson(Map<String, dynamic> json) =>
      _$CategoriaServicioModelFromJson(json);
  factory CategoriaServicioModel.fromEntry(CategoriaServicioEntry entry) => CategoriaServicioModel(
    id: entry.id,
    nombre: entry.nombre,
    estatus: entry.estatus,
    fechaCreacion: entry.fechaCreacion,
    fechaActualizacion: entry.fechaActualizacion,
    fechaEliminacion: entry.fechaEliminacion,
  );
}
