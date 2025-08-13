import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../../core/database/app_database.dart';

part 'precio_concepto_model.freezed.dart';
part 'precio_concepto_model.g.dart';

@freezed
sealed class PreciosConceptosModel with _$PreciosConceptosModel {
  const factory PreciosConceptosModel({
    required int id,
    required int itemId,
    required int sizeRopaId,
    required int diasEntrega,
    required String tipoUnidad,
    required double importe,
    required DateTime fechaCreacion,
    DateTime? fechaActualizacion,
    DateTime? fechaEliminacion,
  }) = _PreciosConceptosModel;

  factory PreciosConceptosModel.fromJson(Map<String, dynamic> json) =>
      _$PreciosConceptosModelFromJson(json);
  factory PreciosConceptosModel.fromEntry(PreciosConceptosEntry entry) => PreciosConceptosModel(
    id: entry.id,
    itemId: entry.itemId,
    sizeRopaId: entry.sizeRopaId,
    diasEntrega: entry.diasEntrega,
    tipoUnidad: entry.tipoUnidad,
    importe: entry.importe,
    fechaCreacion: entry.fechaCreacion,
    fechaActualizacion: entry.fechaActualizacion,
    fechaEliminacion: entry.fechaEliminacion,
  );
  
}
