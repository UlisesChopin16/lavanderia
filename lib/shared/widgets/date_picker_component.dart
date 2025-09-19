import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lavanderia/core/extensions/date_time_ext.dart';
import 'package:lavanderia/core/utils/icons_manager.dart';

class DatePickerComponent extends StatefulWidget {
  final DateTime? currentDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime?> changeDate;
  final VoidCallback? onDelete;
  final double? width;
  final String? labelText;
  final bool showTodayButton;

  const DatePickerComponent({
    super.key,
    required this.changeDate,
    this.onDelete,
    this.currentDate,
    this.firstDate,
    this.lastDate,
    this.width,
    this.labelText,
    this.showTodayButton = false,
  });

  @override
  State<DatePickerComponent> createState() => _DatePickerComponentState();
}

class _DatePickerComponentState extends State<DatePickerComponent> {
  bool isEnable = true;
  final TextEditingController controller = TextEditingController();
  DateTime? get currentDate => widget.currentDate;

  @override
  Widget build(BuildContext context) {
    if (widget.currentDate == null) {
      controller.text = "";
    } else {
      controller.text = currentDate.formatDate;
    }

    return TextField(
      controller: controller,
      enabled: isEnable,
      readOnly: true,
      style: const TextStyle(
        fontSize: 16,
        // color: Colors.black,
      ),
      decoration: InputDecoration(
        labelText: widget.labelText ?? 'Selecciona una fecha',
        constraints: BoxConstraints(
          maxHeight: 40,
          maxWidth: widget.width ?? 160,
        ),
        prefixIcon: const Icon(
          IconsManager.calendar,
        ),
      ),
      onTap: () async {
        FocusScope.of(context).unfocus();
        FocusScope.of(context).requestFocus(FocusNode());

        setState(() {
          isEnable = false;
        });

        final (
          currentDate,
          calculateFirstDate,
          calculateLastDate,
        ) = calculateDates();

        await showDialog(
          // barrierDismissible: false,
          context: context,
          builder: (context) {
            return CalendarDialog(
              currentDate: currentDate,
              calculateFirstDate: calculateFirstDate,
              calculateLastDate: calculateLastDate,
              changeDate: (date) {
                widget.changeDate(date);
              },
            );
          },
        );
        setState(() {
          isEnable = true;
        });
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

  (DateTime currentDate, DateTime firstDate, DateTime lastDate) calculateDates() {
    DateTime calculateFirstDate = widget.firstDate ?? DateTime(2000);

    if (widget.lastDate != null && widget.lastDate!.isBefore(calculateFirstDate)) {
      calculateFirstDate = widget.lastDate!;
    }

    DateTime calculateLastDate = widget.lastDate ?? DateTime.now();

    if (widget.firstDate != null && widget.firstDate!.isAfter(calculateLastDate)) {
      calculateLastDate = widget.firstDate!;
    }

    DateTime currentDate = widget.currentDate ?? DateTime.now();

    currentDate = currentDate.clampDate(
      calculateFirstDate,
      calculateLastDate,
    );

    return (currentDate, calculateFirstDate, calculateLastDate);
  }
}

class CalendarDialog extends StatefulWidget {
  final DateTime currentDate;
  final DateTime calculateFirstDate;
  final DateTime calculateLastDate;
  final ValueChanged<DateTime?> changeDate;
  final bool showTodayButton;

  const CalendarDialog({
    super.key,
    required this.currentDate,
    required this.calculateFirstDate,
    required this.calculateLastDate,
    required this.changeDate,
    this.showTodayButton = false,
  });

  @override
  State<CalendarDialog> createState() => _CalendarDialogState();
}

class _CalendarDialogState extends State<CalendarDialog> {
  DateTime get currentDate => widget.currentDate;
  DateTime get calculateFirstDate => widget.calculateFirstDate;
  DateTime get calculateLastDate => widget.calculateLastDate;

  late DateTime? selectedDate = currentDate;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      titlePadding: const EdgeInsets.all(0),
      title: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Theme.of(context).appBarTheme.backgroundColor,
          ),
          child: const Row(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  'Selecciona una fecha',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Icon(
                Icons.calendar_month,
                size: 30.0,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
      content: SizedBox(
        width: 300,
        height: 300,
        child: CalendarDatePicker(
          initialDate: currentDate,
          firstDate: calculateFirstDate,
          lastDate: calculateLastDate,
          onDateChanged: (date) {
            setState(() {
              selectedDate = date;
            });
          },
        ),
      ),
      actions: [
        if (widget.showTodayButton)
          TextButton(
            onPressed: () {
              widget.changeDate(DateTime.now());
              context.pop(true);
            },
            child: const Text('Hoy'),
          ),
        TextButton(
          onPressed: () {
            context.pop();
          },
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
          ),
          child: const Text(
            'Cancelar',
            style: TextStyle(
              color: Colors.redAccent,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            widget.changeDate(selectedDate);
            context.pop(true);
          },
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
          ),
          child: Text(
            'Aceptar',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
