import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/features/catalogos/clientes/data/models/cliente_model.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/data/models/history_item/history_item_model.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/data/models/item_con_precio_model/item_con_precio_model.dart';

part 'orden_con_detalles_model.freezed.dart';
part 'orden_con_detalles_model.g.dart';

@freezed
sealed class OrdenConDetallesModel with _$OrdenConDetallesModel {
  const factory OrdenConDetallesModel({
    required int id,
    required ClienteModel cliente,
    required String folio,
    String? descripcion,
    required HistoryItemModel itemHistory,
    required String estatus,
    required double total,
    required double restante,
    required DateTime fechaCreacion,
    DateTime? fechaCierre,
    @Default([]) List<ItemConPrecioModel> items
    
  }) = _OrdenConDetallesModel;

  factory OrdenConDetallesModel.fromJson(Map<String, dynamic> json) => _$OrdenConDetallesModelFromJson(json);
}