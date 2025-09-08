import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lavanderia/features/catalogos/precios/domain/entities/precio_con_detalles_entity/precio_con_detalles_entity.dart';
import 'package:lavanderia/features/catalogos/precios/presentation/views/view_model/precios_view_model.dart';

import 'create_precios_fields/create_precios_fields.dart';

class RowFieldsPrecio extends ConsumerWidget {
  final PrecioConDetallesEntity precio;
  final ValueChanged<PrecioConDetallesEntity> onChangePrecio;

  const RowFieldsPrecio({
    super.key,
    required this.precio,
    required this.onChangePrecio,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (categoria, size) = ref.watch(
      preciosViewModelProvider.select(
        (state) => (state.categoria, state.sizeRopa),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 20,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            children: [
              NameField(
                name: precio.nombreConcepto,
                onNameChanged: (value) {
                  onChangePrecio(
                    precio.copyWith(nombreConcepto: value),
                  );
                },
              ),
              DiasField(
                dias: precio.diasEntrega.toString(),
                onDiasChanged: (value) {
                  onChangePrecio(
                    precio.copyWith(diasEntrega: int.parse(value.isEmpty ? '0' : value)),
                  );
                },
              ),
              ImporteField(
                importe: precio.importe.toString(),
                onPrecioChanged: (value) {
                  onChangePrecio(
                    precio.copyWith(importe: double.parse(value.isEmpty ? '0.0' : value)),
                  );
                },
              ),
            ],
          ),
          Wrap(
            spacing: 20,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            children: [
              if (categoria == null)
                SelectCategoria(
                  categoriaValue: precio.categoria,
                  onCategoriaChanged: (value) {
                    onChangePrecio(
                      precio.copyWith(
                        categoria: value,
                        diasEntrega: value.diasEntrega,
                      ),
                    );
                  },
                ),
              if (size == null)
                SelectSize(
                  sizeRopa: precio.size,
                  onSizeChanged: (value) {
                    onChangePrecio(
                      precio.copyWith(size: value),
                    );
                  },
                ),
              SelectUnit(
                unitType: precio.tipoUnidad,
                onUnitChanged: (value) {
                  onChangePrecio(
                    precio.copyWith(
                      tipoUnidad: value,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
