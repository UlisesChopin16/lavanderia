import 'package:flutter_test/flutter_test.dart';
import 'package:lavanderia/core/utils/printer.dart';
import 'package:lavanderia/features/ordenes_servicio/lista_ordenes_servicio/domain/usecases/obtain_items.dart';

void main() {
  group('Prueba de listas', () {
    test('Verificar que una lista vacía tiene longitud 0', () {
      final lista = <ItemConPrecioEntity>[
        ItemConPrecioEntity(
          estaEntregado: true,
          fechaEntrega: DateTime.now(),
        ),
        ItemConPrecioEntity(
          estaEntregado: false,
          fechaEntrega: DateTime.now(),
        ),
        ItemConPrecioEntity(
          estaEntregado: true,
          fechaEntrega: DateTime.now(),
        ),
        ItemConPrecioEntity(
          estaEntregado: true,
          fechaEntrega: DateTime.now().add(const Duration(days: 2)),
        ),
        ItemConPrecioEntity(
          estaEntregado: false,
          fechaEntrega: DateTime.now().add(const Duration(days: 2)),
        ),
        ItemConPrecioEntity(
          estaEntregado: false,
          fechaEntrega: DateTime.now().add(const Duration(days: 2)),
        ),
        ItemConPrecioEntity(
          estaEntregado: true,
          fechaEntrega: DateTime.now().add(const Duration(days: 3)),
        ),
        ItemConPrecioEntity(
          estaEntregado: false,
          fechaEntrega: DateTime.now().add(const Duration(days: 2)),
        ),
        ItemConPrecioEntity(
          estaEntregado: true,
          fechaEntrega: DateTime.now(),
        ),
        ItemConPrecioEntity(
          estaEntregado: true,
          fechaEntrega: DateTime.now().add(const Duration(days: 3)),
        ),
      ];

      lista.sort((a, b) {
        // 1. primero ordenar por entregado/no entregado
        if (a.estaEntregado != b.estaEntregado) {
          return a.estaEntregado ? 1 : -1; // entregados van al final
        }

        // 2. dentro de cada grupo ordenar por fecha
        final dateA = a.fechaEntrega ?? DateTime.now();
        final dateB = b.fechaEntrega ?? DateTime.now();
        return dateA.compareTo(dateB);
      });

      for (var item in lista) {
        Printer.i('Entregado: ${item.estaEntregado}, Fecha Entrega: ${item.fechaEntrega}');
      }
    });
  });
}
