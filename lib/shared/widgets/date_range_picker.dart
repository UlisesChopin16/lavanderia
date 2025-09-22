import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lavanderia/core/extensions/date_time_ext.dart';
import 'package:lavanderia/core/types/range_dates_types.dart';
import 'package:lavanderia/core/utils/icons_manager.dart';
import 'package:lavanderia/core/utils/printer.dart';
import 'package:lavanderia/shared/dialogs/base_dialog.dart';
import 'package:lavanderia/shared/widgets/delete_button.dart';

class DateRangePicker extends StatefulWidget {
  final bool? showDelete;
  final List<DateTime?> selectedDates;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<List<DateTime?>>? changeDate;
  final VoidCallback? onDelete;
  final double? width;
  final String? labelText;

  const DateRangePicker({
    super.key,
    this.showDelete,
    this.changeDate,
    this.onDelete,
    this.selectedDates = const [],
    this.firstDate,
    this.lastDate,
    this.width,
    this.labelText,
  });

  @override
  State<DateRangePicker> createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  final TextEditingController controller = TextEditingController();
  List<DateTime?> get selectedDates => widget.selectedDates;

  Widget? get leading {
    // Decide si debe mostrar el botón de borrar
    final shouldShowDelete = widget.showDelete ?? selectedDates.isNotEmpty;

    if (shouldShowDelete) {
      return DeleteButton(
        onPressed: () {
          setState(controller.clear);
          widget.onDelete?.call();
        },
      );
    }

    return const Icon(IconsManager.calendarRange);
  }

  @override
  Widget build(BuildContext context) {
    if (selectedDates.isEmpty) {
      controller.text = "";
    } else {
      controller.text = selectedDates.map((date) => date.formatDate).join(" - ");
    }

    return TextField(
      controller: controller,
      readOnly: true,
      style: const TextStyle(
        fontSize: 12,
        // color: Colors.black,
      ),
      decoration: InputDecoration(
        labelText: widget.labelText ?? 'Selecciona las fechas',
        hintText: '01/01/2023 - 31/01/2023',
        constraints: BoxConstraints(
          maxHeight: 40,
          maxWidth: widget.width ?? 230,
        ),
        // prefixIcon: const Icon(
        //   IconsManager.calendarRange,
        // ),
        prefixIcon: leading,
      ),
      onTap: () async {
        FocusScope.of(context).unfocus();
        FocusScope.of(context).requestFocus(FocusNode());

        final (
          calculateFirstDate,
          calculateLastDate,
        ) = calculateDates();

        await showDialog(
          // barrierDismissible: false,
          context: context,
          builder: (context) {
            return RangeDialog(
              firstDate: calculateFirstDate,
              lastDate: calculateLastDate,
              selectedDates: selectedDates,
              changeDate: (dates) {
                widget.changeDate?.call(dates);
              },
            );
          },
        );
      },
    );
  }

  /// Calculates the first date, last date, and current date based on the provided parameters.
  ///
  /// The [widget.currentDate] parameter represents the current date.
  /// The [widget.firstDate] parameter represents the first selectable date.
  /// The [widget.lastDate] parameter represents the last selectable date.
  ///
  /// If [widget.firstDate] is null, the default value is set to January 1, 2000.
  /// If [widget.lastDate] is null, the default value is set to the current date.
  ///
  /// The calculated first date is determined by comparing [widget.firstDate] and [widget.lastDate].
  /// If [widget.lastDate] is before [widget.firstDate], [widget.lastDate] is used as the first date.
  ///
  /// The calculated last date is determined by comparing [widget.firstDate] and [widget.lastDate].
  /// If [widget.firstDate] is after [widget.lastDate], [widget.firstDate] is used as the last date.
  ///
  /// The current date is set to the provided [widget.currentDate] or the current date if [widget.currentDate] is null.
  ///
  /// The calculated current date is clamped between the calculated first date and last date.
  ///
  /// Returns a tuple containing the calculated current date, first date, and last date.

  (DateTime firstDate, DateTime lastDate) calculateDates() {
    DateTime calculateFirstDate = widget.firstDate ?? DateTime(2000);

    if (widget.lastDate != null && widget.lastDate!.isBefore(calculateFirstDate)) {
      calculateFirstDate = widget.lastDate!;
    }

    DateTime calculateLastDate = widget.lastDate ?? DateTime.now();

    if (widget.firstDate != null && widget.firstDate!.isAfter(calculateLastDate)) {
      calculateLastDate = widget.firstDate!;
    }

    return (calculateFirstDate, calculateLastDate);
  }
}

class RangeDialog extends StatefulWidget {
  final List<DateTime?> selectedDates;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<List<DateTime?>>? changeDate;

  const RangeDialog({
    super.key,
    required this.firstDate,
    required this.lastDate,
    this.changeDate,
    this.selectedDates = const [],
  });

  @override
  State<RangeDialog> createState() => _RangeDialogState();
}

class _RangeDialogState extends State<RangeDialog> {
  late List<DateTime?> selectedDates = widget.selectedDates;
  ValueChanged<List<DateTime?>> get onChange => widget.changeDate!;
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: 'Selecciona las fechas',
      onActionPressed: () {
        widget.changeDate?.call(selectedDates);
        context.pop();
      },
      content: SizedBox(
        width: 325,
        // height: 400,
        child: Column(
          children: [
            CalendarDatePicker2(
              config: CalendarDatePicker2Config(
                calendarType: CalendarDatePicker2Type.range,
                rangeBidirectional: true,
                firstDate: widget.firstDate,
                lastDate: widget.lastDate,
                centerAlignModePicker: true,
                selectedDayHighlightColor: Theme.of(context).colorScheme.primary,
                allowSameValueSelection: true,
                // selectableDayPredicate: (day) => day,
              ),
              value: selectedDates,
              onValueChanged: (dates) {
                setState(() {
                  Printer.i(dates);
                  selectedDates = dates;
                  selectedIndex = 0;
                });
              },
            ),
            Wrap(
              alignment: WrapAlignment.end,
              spacing: 10,
              runSpacing: 10,

              children: [
                ...List.generate(RangeDatesTypes.values.length, (index) {
                  final rangeType = RangeDatesTypes.values[index];
                  final newIndex = index + 1;
                  return SelectedTextButton(
                    isSelected: selectedIndex == newIndex,
                    text: rangeType.title,
                    onPressed: () {
                      setState(() {
                        selectedDates = rangeType.range;
                        selectedIndex = newIndex;
                      });
                    },
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SelectedTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isSelected;
  final String text;
  const SelectedTextButton({
    super.key,
    required this.onPressed,
    required this.isSelected,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: isSelected
          ? TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            )
          : null,
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
