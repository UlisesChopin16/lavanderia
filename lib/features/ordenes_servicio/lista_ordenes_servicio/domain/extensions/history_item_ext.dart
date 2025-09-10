import 'package:lavanderia/core/database/app_database.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/data/models/history_item/history_item_model.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/entities/history_item/history_item_entity.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/types/metodo_pago_type.dart';

extension OrdenHistoryEntryExt on OrdenHistoryEntry {
  HistoryItemModel toModel() {
    return HistoryItemModel(
      id: id,
      ordenId: ordenId,
      monto: monto,
      metodoPago: metodoPago,
      fecha: fecha,
    );
  }
}

extension HistoryItemModelExt on HistoryItemModel {
  HistoryItemEntity toEntity() {
    return HistoryItemEntity(
      id: id,
      ordenId: ordenId,
      monto: monto,
      metodoPago: MetodoPagoType.fromString(metodoPago),
      fecha: fecha,
    );
  }
}
