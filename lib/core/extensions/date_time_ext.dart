import 'package:lavanderia/core/utils/constants_manager.dart';

extension DateTimeExt on DateTime {
  String get formatDate => ConstantsManager.formatDateTime(this);
  String get fullDateFormat => ConstantsManager.fullDateFormat(this);
}

extension DateTimeNullExt on DateTime? {
  String get formatDate => ConstantsManager.formatDateTime(this);
  String get fullDateFormat => ConstantsManager.fullDateFormat(this);
}

