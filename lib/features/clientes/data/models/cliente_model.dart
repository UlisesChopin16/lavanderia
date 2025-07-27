import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/database/app_database.dart';

part 'cliente_model.freezed.dart';
part 'cliente_model.g.dart';

@freezed
sealed class ClienteModel with _$ClienteModel {
  const factory ClienteModel({
    required int id,
    required String nombres,
    required String apellidos,
    required String correo,
    required String telefono,
    required DateTime fechaCreacion,
    DateTime? fechaActualizacion,
    DateTime? fechaEliminacion,
  }) = _ClienteModel;

  factory ClienteModel.fromEntry(ClienteEntry entry) => ClienteModel(
    id: entry.id,
    nombres: entry.nombres,
    apellidos: entry.apellidos,
    correo: entry.correo,
    telefono: entry.telefono,
    fechaCreacion: entry.fechaCreacion,
    fechaActualizacion: entry.fechaActualizacion,
    fechaEliminacion: entry.fechaEliminacion,
  );

  factory ClienteModel.fromJson(Map<String, dynamic> json) =>
      _$ClienteModelFromJson(json);
}
