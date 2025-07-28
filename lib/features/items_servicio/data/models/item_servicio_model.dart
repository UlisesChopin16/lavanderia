import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/database/app_database.dart';

part 'item_servicio_model.freezed.dart';
part 'item_servicio_model.g.dart';

@freezed
sealed class ItemServicioModel with _$ItemServicioModel {
  const factory ItemServicioModel({
    required int id,
    required String nombre,
    required String estatus,
    required DateTime fechaCreacion,
    DateTime? fechaActualizacion,
    DateTime? fechaEliminacion,
  }) = _ItemServicioModel;

  factory ItemServicioModel.fromEntry(ItemServicioEntry entry) => ItemServicioModel(
    id: entry.id,
    nombre: entry.nombre,
    estatus: entry.estatus,
    fechaCreacion: entry.fechaCreacion,
    fechaActualizacion: entry.fechaActualizacion,
    fechaEliminacion: entry.fechaEliminacion,
  );

  factory ItemServicioModel.fromJson(Map<String, dynamic> json) => _$ItemServicioModelFromJson(json);
}