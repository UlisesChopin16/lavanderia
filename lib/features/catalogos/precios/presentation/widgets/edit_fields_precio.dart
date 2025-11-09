import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lavanderia/core/types/clothe_size_type.dart';
import 'package:lavanderia/features/catalogos/precios/domain/entities/precio_con_detalles_entity/precio_con_detalles_entity.dart';
import 'package:lavanderia/features/catalogos/precios/presentation/views/view_model/precios_view_model.dart';
import 'package:lavanderia/features/presentation/widgets/dropdown_clothe_sizes.dart';

import 'create_precios_fields/create_precios_fields.dart';

class EditFieldsPrecio extends ConsumerWidget {
  final PrecioConDetallesEntity precio;
  final ValueChanged<PrecioConDetallesEntity> onChangePrecio;

  const EditFieldsPrecio({
    super.key,
    required this.precio,
    required this.onChangePrecio,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (categoria) = ref.watch(
      preciosViewModelProvider.select(
        (state) => (state.categoria),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Wrap(
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
                precio.copyWith(nombreConcepto: value),
              );
            },
          ),
          if (categoria == null)
            SelectCategoria(
              categoriaValue: precio.categoria,
              onCategoriaChanged: (value) {
                onChangePrecio(
                  precio.copyWith(categoria: value),
                );
              },
            ),
          DropdownClotheSizes(
            clotheSize: precio.size,
            onSizeChanged: (value) {
              onChangePrecio(
                precio.copyWith(size: value ?? ClotheSizeType.emptySize),
              );
            },
            showDelete: false,
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
    );
  }
}
