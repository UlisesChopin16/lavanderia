import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lavanderia/core/extensions/string_ext.dart';

part 'cliente_entity.freezed.dart';

@freezed
sealed class ClienteEntity with _$ClienteEntity {
  const ClienteEntity._();

  const factory ClienteEntity({
    @Default(-1) int id,
    @Default('') String nombres,
    @Default('') String apellidos,
    @Default('') String correo,
    @Default('') String telefono,
    @Default(null) DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
    DateTime? fechaEliminacion,
  }) = _ClienteEntity;

  String get firstName {
    if (nombres.trim().isEmpty) return '';
    return nombres.trim().split(' ').first;
  }
  
  String get fullName => '$nombres $apellidos';

  String validate() {
    final errors = <String>[];

    if (nombres.normalizeSpaces().isEmpty) {
      errors.add(' - El nombre del concepto es obligatorio');
    }
    if (apellidos.normalizeSpaces().isEmpty) {
      errors.add(' - El apellido del concepto es obligatorio');
    }
    // if (correo.normalizeSpaces().isEmpty) {
    //   errors.add(' - El correo del concepto es obligatorio');
    // }
    if (correo.normalizeSpaces().isNotEmpty && !correo.isEmail) {
      errors.add(' - El correo no tiene un formato válido');
    }
    if (telefono.normalizeSpaces().isEmpty) {
      errors.add(' - El teléfono del concepto es obligatorio');
    }
    if (telefono.normalizeSpaces().isNotEmpty && telefono.length < 10) {
      errors.add(' - El teléfono debe tener 10 dígitos');
    }

    return errors.join('\n');
  }
}
