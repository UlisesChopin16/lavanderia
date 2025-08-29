import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/features/catalogos/categorias/domain/entities/categoria_servicio_entity.dart';
import 'package:lavanderia/features/catalogos/precios/domain/entities/filtros/filtros_precios.dart';
import 'package:lavanderia/features/catalogos/precios/presentation/views/view_model/precios_view_model.dart';
import 'package:lavanderia/features/catalogos/sizes/domain/entities/sizes_ropa/size_ropa_entity.dart';

class PreciosView extends ConsumerStatefulWidget {
  final CategoriaServicioEntity? categoria;
  final SizesRopaEntity? sizeRopa;
  const PreciosView({
    super.key,
    this.categoria,
    this.sizeRopa,
  });

  @override
  ConsumerState<PreciosView> createState() => _PreciosViewState();
}

class _PreciosViewState extends ConsumerState<PreciosView> {
  CategoriaServicioEntity? get categoria => widget.categoria;
  SizesRopaEntity? get sizeRopa => widget.sizeRopa;

  List<ColumnPreciosName> get columns {
    const  values = ColumnPreciosName.values;

    if (categoria != null) {
      values.remove(ColumnPreciosName.categoria);
    }
    if (sizeRopa != null) {
      values.remove(ColumnPreciosName.sizeRopa);
    }
    return values;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final preciosNotifier = ref.read(preciosViewModelProvider.notifier);
      // Acción a realizar después de que se haya construido el widget
      preciosNotifier.clearAll();
      preciosNotifier.init(categoria, sizeRopa);

      if(categoria != null) {
        await preciosNotifier.getCategorias();
      }

      if(sizeRopa != null) {
        await preciosNotifier.getSizesRopa();
      }


    });
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 800,
        child: Card(
          // child: TableCardInfo(
          //   titleAddButton: 'Agregar categoría de ropa',
          //   onAddButtonPressed: () {
          //     // Acción al presionar el botón de agregar categoría
          //     Printer.d('Agregar Categoría presionado');
          //   },
          //   onSearchChanged: (value) {
          //     // Acción al cambiar el texto de búsqueda
          //     Printer.d('Buscar: $value');
          //   },

          //     columns: [
          //       const DataColumn(label: Text('ID')),
          //       DataColumn(
          //         label: const Text('Nombre'),
          //         onSort: (columnIndex, ascending) => ascending
          //             ? Printer.d('Ordenar por Nombre Ascendente')
          //             : Printer.d('Ordenar por Nombre Descendente'),
          //       ),
          //       const DataColumn(label: Text('Activo')),
          //     ],
          //     rows: const [
          //       DataRow(cells: [
          //         DataCell(Text('1')),
          //         DataCell(Text('Pequeño')),
          //         DataCell(Text('Sí')),
          //       ]),
          //       DataRow(cells: [
          //         DataCell(Text('2')),
          //         DataCell(Text('Mediano')),
          //         DataCell(Text('No')),
          //       ]),
          //       DataRow(cells: [
          //         DataCell(Text('2')),
          //         DataCell(Text('Mediano')),
          //         DataCell(Text('No')),
          //       ]),
          //     ],
          // ),
        ),
      ),
    );
  }
}
