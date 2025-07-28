import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/database/app_database.dart';

part 'orden_servicio_model.freezed.dart';
part 'orden_servicio_model.g.dart';

@freezed
sealed class OrdenServicioModel with _$OrdenServicioModel{
  const factory OrdenServicioModel({
    required int id,
    required int clienteId,
    required int folio,
    required int estatusUrgenciaId,
    required DateTime fechaEntrega,
    required DateTime fechaLista,
    required DateTime fechaRecogida,
    String? descripcion,
    required String estatus,
    required double total,
    required String metodoPago,
    double? pago,
    required DateTime fechaCreacion,
    DateTime? fechaActualizacion,
    DateTime? fechaEliminacion,
  }) = _OrdenServicioModel;

  factory OrdenServicioModel.fromEntry(
    OrdenServicioEntry entry, {
    List<ItemServicioOrdenEntry> itemEntries = const [],
  }) =>
      OrdenServicioModel(
        id: entry.id,
        clienteId: entry.clienteId,
        folio: entry.folio,
        estatusUrgenciaId: entry.estatusUrgenciaId,
        fechaEntrega: entry.fechaEntrega,
        fechaLista: entry.fechaLista,
        fechaRecogida: entry.fechaRecogida,
        descripcion: entry.descripcion,
        estatus: entry.estatus,
        total: entry.total,
        metodoPago: entry.metodoPago,
        pago: entry.pago,
        fechaCreacion: entry.fechaCreacion,
        fechaActualizacion: entry.fechaActualizacion,
        fechaEliminacion: entry.fechaEliminacion,
      );

  factory OrdenServicioModel.fromJson(Map<String, dynamic> json) =>
      _$OrdenServicioModelFromJson(json);
}

@freezed
sealed class ItemOrdenModel with _$ItemOrdenModel{
  const factory ItemOrdenModel({
    required int id,
    required int ordenId,
    required int itemId,
    required double cantidad,
    required double importe,
    required DateTime fechaCreacion,
    DateTime? fechaActualizacion,
    DateTime? fechaEliminacion,
  }) = _ItemOrdenModel;

  factory ItemOrdenModel.fromEntry(ItemServicioOrdenEntry entry) => ItemOrdenModel(
    id: entry.id,
    ordenId: entry.ordenId,
    itemId: entry.itemId,
    cantidad: entry.cantidad,
    importe: entry.importe,
    fechaCreacion: entry.fechaCreacion,
    fechaActualizacion: entry.fechaActualizacion,
    fechaEliminacion: entry.fechaEliminacion,
  );

  factory ItemOrdenModel.fromJson(Map<String, dynamic> json) =>
      _$ItemOrdenModelFromJson(json);
}