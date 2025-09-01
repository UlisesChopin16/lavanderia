import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/views/view_model/configuracion_empresa_view_model.dart';

class DatosDireccionWrap extends ConsumerWidget {
  final double widthField;
  const DatosDireccionWrap({super.key, required this.widthField});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configuracionNotifier = ref.read(configuracionEmpresaViewModelProvider.notifier);
    final (direccion) = ref.watch(
      configuracionEmpresaViewModelProvider.select(
        (value) => (value.direccion),
      ),
    );
    final codigoPostal = direccion.codigoPostal == -1 ? '' : direccion.codigoPostal.toString();
    return Wrap(
      spacing: 15,
      runSpacing: 15,
      children: [
        TextFormField(
          initialValue: direccion.calle,
          decoration: InputDecoration(
            constraints: BoxConstraints(maxWidth: widthField),
            labelText: 'Nombre de la Calle',
            hintText: 'Ingrese el nombre de la calle',
          ),
          onChanged: (value) => configuracionNotifier.setDireccion(
            direccion.copyWith(calle: value),
          ),
        ),
        TextFormField(
          initialValue: direccion.numeroExterior,
          decoration: InputDecoration(
            constraints: BoxConstraints(maxWidth: widthField),
            labelText: 'Número Exterior',
            hintText: 'Ingrese el número exterior',
          ),
          onChanged: (value) => configuracionNotifier.setDireccion(
            direccion.copyWith(numeroExterior: value),
          ),
        ),
        TextFormField(
          initialValue: direccion.numeroInterior,
          decoration: InputDecoration(
            constraints: BoxConstraints(maxWidth: widthField),
            labelText: 'Número Interior (opcional)',
            hintText: 'Ingrese el número interior (opcional)',
          ),
          onChanged: (value) => configuracionNotifier.setDireccion(
            direccion.copyWith(numeroInterior: value),
          ),
        ),
        TextFormField(
          initialValue: direccion.colonia,
          decoration: InputDecoration(
            constraints: BoxConstraints(maxWidth: widthField),
            labelText: 'Colonia',
            hintText: 'Ingrese la colonia',
          ),
          onChanged: (value) => configuracionNotifier.setDireccion(
            direccion.copyWith(colonia: value),
          ),
        ),
        TextFormField(
          initialValue: direccion.ciudad,
          decoration: InputDecoration(
            constraints: BoxConstraints(maxWidth: widthField),
            labelText: 'Ciudad',
            hintText: 'Ingrese la ciudad',
          ),
          onChanged: (value) => configuracionNotifier.setDireccion(
            direccion.copyWith(ciudad: value),
          ),
        ),
        TextFormField(
          initialValue: direccion.estado,
          decoration: InputDecoration(
            constraints: BoxConstraints(maxWidth: widthField),
            labelText: 'Estado',
            hintText: 'Ingrese el estado',
          ),
          onChanged: (value) => configuracionNotifier.setDireccion(
            direccion.copyWith(estado: value),
          ),
        ),
        TextFormField(
          initialValue: codigoPostal,
          decoration: InputDecoration(
            constraints: BoxConstraints(maxWidth: widthField),
            labelText: 'Código Postal',
            hintText: 'Ingrese el código postal',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(5),
          ],
          onChanged: (value) => configuracionNotifier.setDireccion(
            direccion.copyWith(codigoPostal: int.parse(value)),
          ),
        ),
      ],
    );
  }
}
