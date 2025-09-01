import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lavanderia/app/theme/color_row_theme.dart';
import 'package:lavanderia/core/types/callbacks_types.dart';
import 'package:lavanderia/features/catalogos/precios/domain/entities/precio_con_detalles_entity/precio_con_detalles_entity.dart';
import 'package:lavanderia/features/catalogos/precios/presentation/views/view_model/precios_view_model.dart';

import 'create_precios_fields/create_precios_fields.dart';

class RowFieldsPrecio extends ConsumerWidget {
  final int index;
  final PrecioConDetallesEntity precio;
  final IndexValueChange<PrecioConDetallesEntity> onChangePrecio;
  final VoidCallback onRemove;

  const RowFieldsPrecio({
    super.key,
    required this.index,
    required this.precio,
    required this.onChangePrecio,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorRowTheme = Theme.of(context).extension<ColorRowTheme>();
    final (categoria, size) = ref.watch(
      preciosViewModelProvider.select(
        (state) => (state.categoria, state.sizeRopa),
      ),
    );
    final newIndex = index + 1;
    return Container(
      color: colorRowTheme?.getColor(newIndex),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        spacing: 15,
        children: [
          Row(
            children: [
              Text('Concepto #$newIndex'),
              const Spacer(),
              InkWell(
                onTap: onRemove,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Wrap(
            spacing: 15,
            runSpacing: 10,
            runAlignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.end,
            alignment: WrapAlignment.end,
            children: [
              NameField(
                name: precio.nombreConcepto,
                onNameChanged: (value) {
                  onChangePrecio(
                    index,
                    precio.copyWith(nombreConcepto: value),
                  );
                },
              ),
              if (categoria == null)
                SelectCategoria(
                  categoriaValue: precio.categoria,
                  onCategoriaChanged: (value) {
                    onChangePrecio(
                      index,
                      precio.copyWith(categoria: value),
                    );
                  },
                ),
              if (size == null)
                SelectSize(
                  sizeRopa: precio.size,
                  onSizeChanged: (value) {
                    onChangePrecio(
                      index,
                      precio.copyWith(size: value),
                    );
                  },
                ),
              SelectUnit(
                unitType: precio.tipoUnidad,
                onUnitChanged: (value) {
                  onChangePrecio(
                    index,
                    precio.copyWith(
                      tipoUnidad: value,
                    ),
                  );
                },
              ),
              DiasField(
                dias: precio.diasEntrega.toString(),
                onDiasChanged: (value) {
                  onChangePrecio(
                    index,
                    precio.copyWith(diasEntrega: int.parse(value.isEmpty ? '0' : value)),
                  );
                },
              ),
              ImporteField(
                importe: precio.importe.toString(),
                onPrecioChanged: (value) {
                  onChangePrecio(
                    index,
                    precio.copyWith(importe: double.parse(value.isEmpty ? '0.0' : value)),
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
