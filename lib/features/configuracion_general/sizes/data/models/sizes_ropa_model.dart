import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../../core/database/app_database.dart';

part 'sizes_ropa_model.freezed.dart';
part 'sizes_ropa_model.g.dart';

@freezed
sealed class SizesRopaModel with _$SizesRopaModel {
  const factory SizesRopaModel({
    required int id,
    required String nombre,
    required String estatus,
    required DateTime fechaCreacion,
    DateTime? fechaActualizacion,
    DateTime? fechaEliminacion,
  }) = _SizesRopaModel;

  factory SizesRopaModel.fromJson(Map<String, dynamic> json) =>
      _$SizesRopaModelFromJson(json);
  factory SizesRopaModel.fromEntry(SizesRopaEntry entry) => SizesRopaModel(
    id: entry.id,
    nombre: entry.nombre,
    estatus: entry.estatus,
    fechaCreacion: entry.fechaCreacion,
    fechaActualizacion: entry.fechaActualizacion,
    fechaEliminacion: entry.fechaEliminacion,
  );
}
