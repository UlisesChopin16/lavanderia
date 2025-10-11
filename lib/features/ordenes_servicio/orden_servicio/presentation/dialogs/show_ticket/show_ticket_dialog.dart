import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lavanderia/core/extensions/build_context_ext.dart';
import 'package:lavanderia/core/extensions/date_time_ext.dart';
import 'package:lavanderia/core/utils/printer.dart';
import 'package:lavanderia/features/catalogos/precios/domain/entities/precio_con_detalles_entity/precio_con_detalles_entity.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/views/view_model/configuracion_empresa_view_model.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/entities/orden_con_detalles_entity/orden_con_detalles_entity.dart';
import 'package:lavanderia/shared/dialogs/base_dialog.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ShowTicketDialog extends ConsumerStatefulWidget {
  final OrdenConDetallesEntity orden;

  const ShowTicketDialog({super.key, required this.orden});

  @override
  ConsumerState<ShowTicketDialog> createState() => _ShowTicketDialogState();
}

class _ShowTicketDialogState extends ConsumerState<ShowTicketDialog> {
  final globalKey = GlobalKey();
  final ScrollController scrollController = ScrollController();
  bool plantHeight = false;

  OrdenConDetallesEntity get orden => widget.orden;
  List<ItemConPrecioEntity> get items => orden.items;
  double get adelanto => orden.total - orden.restante;
  static const style = TextStyle(
    fontSize: 14,
    color: Colors.black,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    final (logo, direccionCompleta, telefono, email, web) = ref.watch(
      configuracionEmpresaViewModelProvider.select(
        (value) => (
          value.configuracionEmpresa.logo,
          value.configuracionEmpresa.direccion.direccionCompleta,
          value.configuracionEmpresa.telefono,
          value.configuracionEmpresa.correo,
          value.configuracionEmpresa.paginaWeb,
        ),
      ),
    );

    return BaseDialog(
      title: 'Ticket ${orden.folio}',
      onActionPressed: () async {
        try {
          setState(() {
            plantHeight = true;
          });
          RenderRepaintBoundary boundary =
              globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

          // 4K: ancho típico 3840px → depende de tu widget base
          double pixelRatio = 8.0; // escala respecto a la pantalla

          ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
          ByteData? byteData = await image.toByteData(
            format: ui.ImageByteFormat.png,
          );

          Uint8List pngBytes = byteData!.buffer.asUint8List();

          // Guardar como archivo
          final dir = await getApplicationDocumentsDirectory();
          final file = File(p.join(dir.path, 'image4k.png'));
          await file.writeAsBytes(pngBytes);

          setState(() {
            plantHeight = false;
          });
          context.showSuccessDialog('Imagen guardada en: ${file.path}');
        } on Exception catch (e, s) {
          Printer.e('e: $e s: $s');
        }
      },
      content: InteractiveViewer(
        child: Container(
          width: 800,
          color: Colors.black,
          child: Center(
            child: SingleChildScrollView(
              controller: scrollController,
              child: RepaintBoundary(
                key: globalKey,
                child: Container(
                  width: 400,
                  // height: plantHeight ? null : scrollController.position.viewportDimension,
                  padding: const EdgeInsets.all(20),
                  color: Colors.white,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Orden ${orden.folio}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              orden.history.fecha.formatFullDate,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(10),
                      Container(
                        // width: 150,
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(File(logo)),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                              child: Text(
                                'Conceptos',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
                      ),
                      const Gap(10),
                      Column(
                        children: [
                          ...List.generate(
                            items.length,
                            (index) {
                              final item = items[index];
                              return ItemServicio(
                                item: item,
                              );
                            },
                          ),
                        ],
                      ),
                      const Gap(30),
                      Row(
                        spacing: 10,
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Total:',
                                  style: style,
                                ),
                                Text(
                                  'Adelanto:',
                                  style: style,
                                ),
                                Text(
                                  'Restante:',
                                  style: style,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${orden.total.toStringAsFixed(2)}',
                                style: style,
                              ),
                              Text(
                                '\$${adelanto.toStringAsFixed(2)}',
                                style: style,
                              ),
                              Text(
                                '\$${orden.restante.toStringAsFixed(2)}',
                                style: style,
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: Column(
                      //     children: [
                      //       Row(
                      //         children: [
                      //           const Expanded(
                      //             child: Text(
                      //               'Total:',
                      //               style: TextStyle(
                      //                 fontSize: 16,
                      //                 fontWeight: FontWeight.bold,
                      //                 color: Colors.black,
                      //               ),
                      //             ),
                      //           ),
                      //           Text(
                      //             '\$${orden.total.toStringAsFixed(2)}',
                      //             style: const TextStyle(
                      //               fontSize: 16,
                      //               fontWeight: FontWeight.bold,
                      //               color: Colors.black,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       Row(
                      //         children: [
                      //           const Expanded(
                      //             child: Text(
                      //               'Adelanto:',
                      //               style: TextStyle(
                      //                 fontSize: 16,
                      //                 fontWeight: FontWeight.bold,
                      //                 color: Colors.black,
                      //               ),
                      //             ),
                      //           ),
                      //           Text(
                      //             '\$${adelanto.toStringAsFixed(2)}',
                      //             style: const TextStyle(
                      //               fontSize: 16,
                      //               fontWeight: FontWeight.bold,
                      //               color: Colors.black,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       Row(
                      //         children: [
                      //           const Expanded(
                      //             child: Text(
                      //               'Restante:',
                      //               style: TextStyle(
                      //                 fontSize: 16,
                      //                 fontWeight: FontWeight.bold,
                      //                 color: Colors.black,
                      //               ),
                      //             ),
                      //           ),
                      //             Text(
                      //               '\$${orden.restante.toStringAsFixed(2)}',
                      //               style: const TextStyle(
                      //                 fontSize: 16,
                      //                 fontWeight: FontWeight.bold,
                      //                 color: Colors.black,
                      //               ),
                      //             ),
                      //           DataCell(
                      //             Text(
                      //               '\$${orden.total.toStringAsFixed(2)}',
                      //               style: const TextStyle(
                      //                 fontSize: 16,
                      //                 fontWeight: FontWeight.bold,
                      //                 color: Colors.black,
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       DataRow(
                      //         cells: [
                      //           const DataCell(
                      //             Text(
                      //               'Adelanto:',
                      //               style: TextStyle(
                      //                 fontSize: 16,
                      //                 fontWeight: FontWeight.bold,
                      //                 color: Colors.black,
                      //               ),
                      //             ),
                      //           ),
                      //           DataCell(
                      //             Text(
                      //               '\$${adelanto.toStringAsFixed(2)}',
                      //               style: const TextStyle(
                      //                 fontSize: 16,
                      //                 fontWeight: FontWeight.bold,
                      //                 color: Colors.black,
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       DataRow(
                      //         cells: [
                      //           const DataCell(
                      //             Text(
                      //               'Restante:',
                      //               style: TextStyle(
                      //                 fontSize: 16,
                      //                 fontWeight: FontWeight.bold,
                      //                 color: Colors.black,
                      //               ),
                      //             ),
                      //           ),
                      //           DataCell(
                      //             Text(
                      //               '\$${orden.restante.toStringAsFixed(2)}',
                      //               style: const TextStyle(
                      //                 fontSize: 16,
                      //                 fontWeight: FontWeight.bold,
                      //                 color: Colors.black,
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // child: Column(
                      //   crossAxisAlignment: CrossAxisAlignment.end,
                      //   children: [
                      //     Text(
                      //       'Total: \$${orden.total.toStringAsFixed(2)}',
                      //       style: const TextStyle(
                      //         fontSize: 18,
                      //         fontWeight: FontWeight.bold,
                      //         color: Colors.black,
                      //       ),
                      //     ),
                      //     Text(
                      //       'Adelanto: \$${adelanto.toStringAsFixed(2)}',
                      //       style: const TextStyle(
                      //         fontSize: 18,
                      //         fontWeight: FontWeight.bold,
                      //         color: Colors.black,
                      //       ),
                      //     ),
                      //     Text(
                      //       'Restante: \$${orden.restante.toStringAsFixed(2)}',
                      //       style: const TextStyle(
                      //         fontSize: 18,
                      //         fontWeight: FontWeight.bold,
                      //         color: Colors.black,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // ),
                      const Divider(),
                      const Gap(20),
                      const Text(
                        '¡Gracias por su preferencia!\n¡Vuelva pronto!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(50),
                      SizedBox(
                        width: 200,
                        child: Text(
                          direccionCompleta,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Gap(30),
                      // Redes Sociales
                      // Numero, correo, web
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (telefono.isNotEmpty)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.phone,
                                  size: 14,
                                  color: Colors.black,
                                ),
                                const Gap(5),
                                Text(
                                  telefono,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          if (email.isNotEmpty)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.email,
                                  size: 14,
                                  color: Colors.black,
                                ),
                                const Gap(5),
                                Text(
                                  email,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ItemServicio extends StatelessWidget {
  final ItemConPrecioEntity item;
  const ItemServicio({super.key, required this.item});

  String get cantidad => isKg ? item.cantidad.toStringAsFixed(2) : item.cantidad.toStringAsFixed(0);

  UnitType get unidad => item.unidad;

  PrecioConDetallesEntity get datosPrecio => item.precio;
  bool get isKg => unidad == UnitType.kilo;

  // String get importe => isKg
  //     ? '${datosPrecio.importe} / ${unidad.value}'
  //     : '${datosPrecio.importe}';

  String get unidades =>
      item.cantidad > 1 ? '$cantidad ${unidad.plural}' : '$cantidad ${unidad.value}';

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.black);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        spacing: 2,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.precio.nombreConcepto,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      '\$${item.importe.toStringAsFixed(2)}',
                      style: labelStyle,
                    ),
                  ],
                ),
                Row(
                  spacing: 10,
                  children: [
                    Text(
                      'Precio: \$${item.precio.importe}',
                      style: labelStyle,
                    ),
                    Text(
                      'Cant: $unidades',
                      style: labelStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }
}
