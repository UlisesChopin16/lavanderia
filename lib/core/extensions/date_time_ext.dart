import 'package:lavanderia/core/utils/constants_manager.dart';

extension DateTimeExt on DateTime {
  String get formatDate => ConstantsManager.formatDateTime(this);
  String get formatFullDate => ConstantsManager.fullDateFormat(this);

  DateTime clampDate(DateTime min, DateTime max) {
    if (isBefore(min)) return min;
    if (isAfter(max)) return max;
    return this;
  }
}

extension DateTimeNullExt on DateTime? {
  String get formatDate => ConstantsManager.formatDateTime(this);
  String get formatFullDate => ConstantsManager.fullDateFormat(this);
}

