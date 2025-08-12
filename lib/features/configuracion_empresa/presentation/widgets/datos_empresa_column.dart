import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/views/view_model/configuracion_empresa_view_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final phoneMask = MaskTextInputFormatter(
    mask: '###-###-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

class DatosEmpresaColumn extends ConsumerWidget {
  final double widthField;
  const DatosEmpresaColumn({super.key, required this.widthField});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configuracionNotifier = ref.read(configuracionEmpresaViewModelProvider.notifier);
    final (configuracion, visiblePassword) = ref.watch(
      configuracionEmpresaViewModelProvider.select(
        (value) => (value.configuracionEmpresa, value.visiblePassword),
      ),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 15,
      children: [
        TextFormField(
          initialValue: configuracion.nombre,
          decoration: InputDecoration(
            constraints: BoxConstraints(maxWidth: widthField),
            labelText: 'Nombre de la Empresa',
            hintText: 'Ingrese el nombre de la empresa',
          ),
          onChanged: configuracionNotifier.setNombre,
        ),
        TextFormField(
          initialValue: configuracion.telefono,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(12),
            phoneMask,
          ],
          decoration: InputDecoration(
            constraints: BoxConstraints(maxWidth: widthField),
            labelText: 'Teléfono',
            hintText: 'Ingrese el teléfono de la empresa',
          ),
          keyboardType: TextInputType.number,
          onChanged: configuracionNotifier.setTelefono,
        ),
        TextFormField(
          initialValue: configuracion.correo,
          decoration: InputDecoration(
            constraints: BoxConstraints(maxWidth: widthField),
            labelText: 'Correo Electrónico',
            hintText: 'Ingrese el correo electrónico de la empresa',
          ),
          onChanged: configuracionNotifier.setCorreo,
        ),
        TextFormField(
          initialValue: configuracion.paginaWeb,
          decoration: InputDecoration(
            constraints: BoxConstraints(maxWidth: widthField),
            labelText: 'Página Web',
            hintText: 'Ingrese la página web de la empresa',
          ),
          onChanged: configuracionNotifier.setPaginaWeb,
        ),
        TextFormField(
          initialValue: configuracion.password,
          obscureText: !visiblePassword,
          onChanged: configuracionNotifier.setPassword,
          decoration: InputDecoration(
            constraints: BoxConstraints(maxWidth: widthField),
            labelText: 'Contraseña',
            hintText: 'Ingrese la contraseña de la empresa',
            suffixIcon: IconButton(
              isSelected: visiblePassword,
              icon: Icon(
                visiblePassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: configuracionNotifier.toggleVisiblePassword,
            ),
          ),
        ),
      ],
    );
  }
}
