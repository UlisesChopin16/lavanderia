import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lavanderia/app/theme/color_row_theme.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/views/view_model/configuracion_empresa_view_model.dart';
import 'package:lavanderia/shared/widgets/actions_button.dart';

import 'button_clear_filters.dart';

export 'package:lavanderia/shared/widgets/actions_button.dart';

/// This widget displays a card with a title, an add button, a search field,
/// optional filters, and a data table.
/// The add button calls the [onAddButtonPressed] callback when pressed.
/// The search field calls the [onSearchChanged] callback when the text changes.
/// The filters are displayed above the table and can be used to filter the data in the table.
/// If in the `DataTable` there aren´t rows, it will display a message indicating that there are no data.
class TableCardInfo extends ConsumerStatefulWidget {
  /// This property add a column with name 'Acciones' at the end of the table.
  /// Add an extra [DataCell] to each [DataRow] with the actions buttons.
  /// Use [ActionsButtons] widget to display the actions buttons.
  /// By default, this property is true.
  /// if this property is false, the table will not have the 'Acciones' column and remove the last
  /// cell of each row.
  final bool showActions;

  final bool ascending;

  /// If true, will display a button to clear filters
  final bool haveFilters;

  /// If true, the table will be displayed in a small view
  final bool isSmall;

  final int sortColumnIndex;

  // final DataTable dataTable;
  final List<DataColumn> columns;
  final List<DataRow> rows;

  /// Filters to be displayed above the table
  /// Each filter should be a widget that can be used to filter the data in the table
  final List<Widget> filters;

  final String titleAddButton;

  /// Callback to be called when the search text changes
  /// The callback receives the search text as a parameter
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<bool>? onSortChange;

  final VoidCallback? onAddButtonPressed;
  final VoidCallback? onClearFilters;
  final Widget smallView;

  const TableCardInfo({
    super.key,
    required this.titleAddButton,
    required this.columns,
    required this.rows,
    required this.smallView,
    required this.ascending,
    required this.isSmall,
    this.onAddButtonPressed,
    this.onClearFilters,
    this.onSearchChanged,
    this.onSortChange,
    this.showActions = true,
    this.filters = const [],
    this.haveFilters = false,
    this.sortColumnIndex = 1,
  });

  @override
  ConsumerState<TableCardInfo> createState() => _TableCardInfoState();
}

class _TableCardInfoState extends ConsumerState<TableCardInfo> {
  final controller = TextEditingController();
  // late int sortColumnIndex = widget.sortColumnIndex;
  bool get isSmall => widget.isSmall;
  bool get showActions => widget.showActions;
  bool get sortAscending => widget.ascending;
  bool get haveFilters => widget.haveFilters;
  int get sortColumnIndex => widget.sortColumnIndex;
  List<Widget> get filters => widget.filters;

  List<DataColumn> get columns {
    List<DataColumn> columnas = widget.columns.map(_buildDataColumn).toList();
    if (showActions) {
      columnas.add(
        const DataColumn(
          label: Text(''),
          headingRowAlignment: MainAxisAlignment.center,
        ),
      );
    }
    return columnas;
  }

  List<DataRow> get rows {
    if (widget.rows.isEmpty) {
      return [];
    }
    return _buildDataRows(widget.rows);
  }

  DataTable get newDataTable {
    return DataTable(
      sortColumnIndex: sortColumnIndex,
      sortAscending: sortAscending,
      columns: columns,
      rows: rows,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            _SearchAndAdd(
              controller: controller,
              widget: widget,
            ),
            const Divider(),
            const Gap(0),
            _Filters(
              onClearFilters: clearFilters,
              haveFilters: haveFilters,
              filters: filters,
            ),
            if (isSmall) widget.smallView else newDataTable,
            if (widget.rows.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Text(
                  'No hay elementos disponibles',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
          ],
        ),
      ),
    );
  }

  DataColumn _buildDataColumn(DataColumn column) {
    final label = column.label as Text;
    final newLabel = Flexible(
      child: Text(
        label.data!,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
    return DataColumn(
      headingRowAlignment: MainAxisAlignment.center,
      label: newLabel,
      numeric: column.numeric,
      tooltip: column.tooltip,
      // onSort: (columnIndex, ascending) {

      //   column.onSort?.call(columnIndex, ascending);
      // },
      onSort: column.onSort,
      columnWidth: column.columnWidth,
      mouseCursor: column.mouseCursor,
    );
  }

  List<DataRow> _buildDataRows(List<DataRow> rows) {
    List<DataRow> newRows = List.from(rows);
    for (var i = 0; i < rows.length; i++) {
      newRows[i] = _buildDataRow(rows[i], i);
    }
    return newRows;
  }

  DataRow _buildDataRow(DataRow row, int index) {
    final colorRowTheme = Theme.of(context).extension<ColorRowTheme>();
    List<DataCell> cells = row.cells.map((cell) => _buildDataCell(cell, index)).toList();

    if (!showActions) {
      cells.removeLast(); // Remove the last cell if actions are not shown
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hoveredColor = !isDark ? Colors.black : Colors.grey[200];

    return DataRow(
      color: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          // All rows will have the same base color
          if (states.contains(WidgetState.hovered)) {
            return hoveredColor;
          }
          // Even rows will have a different color
          return colorRowTheme?.getColor(index + 1);
        },
      ),
      cells: cells,
      key: row.key,
      onSelectChanged: row.onSelectChanged,
      mouseCursor: const WidgetStatePropertyAll(SystemMouseCursors.basic),
      selected: row.selected,
      onLongPress: () {},
    );
  }

  DataCell _buildDataCell(DataCell cell, int index) {
    final child = cell.child;
    final isText = child is Text;
    final newChild = isText
        ? Text(
            child.data!,
            textAlign: TextAlign.center,
          )
        : child;
    return DataCell(
      Center(child: newChild),
      showEditIcon: cell.showEditIcon,
      onTap: cell.onTap,
      placeholder: cell.placeholder,
      onDoubleTap: cell.onDoubleTap,
      onLongPress: cell.onLongPress,
      onTapCancel: cell.onTapCancel,
      onTapDown: cell.onTapDown,
    );
  }

  void clearFilters() {
    controller.clear();
    widget.onClearFilters?.call();
  }
}

class _Filters extends StatelessWidget {
  const _Filters({
    required this.onClearFilters,
    required this.haveFilters,
    required this.filters,
  });

  final void Function()? onClearFilters;
  final bool haveFilters;
  final List<Widget> filters;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      runAlignment: WrapAlignment.end,
      spacing: 10,
      runSpacing: 10,
      children: [
        if (haveFilters)
          ButtonClearFilters(
            onPressed: onClearFilters,
          ),
        ...filters,
      ],
    );
  }
}

class _SearchAndAdd extends HookConsumerWidget {
  const _SearchAndAdd({
    required this.widget,
    required this.controller,
  });

  final TableCardInfo widget;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blockUI = ref.watch(
      configuracionEmpresaViewModelProvider.select((value) => value.blockUI),
    );

    return Wrap(
      // mainAxisSize: MainAxisSize.min,
      // mainAxisAlignment: MainAxisAlignment.end,
      // crossAxisAlignment: CrossAxisAlignment.center,
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      runAlignment: WrapAlignment.end,
      spacing: 15,
      runSpacing: 10,
      children: [
        TextField(
          controller: controller,
          onChanged: widget.onSearchChanged,
          decoration: const InputDecoration(
            constraints: BoxConstraints(maxWidth: 300),
            labelText: 'Buscar',
            suffixIcon: Icon(
              Icons.search,
            ),
          ),
        ),
        if (!blockUI)
          _AddRow(
            titleAddButton: widget.titleAddButton,
            onAddButtonPressed: widget.onAddButtonPressed,
          ),
      ],
    );
  }
}

class _AddRow extends StatelessWidget {
  final String titleAddButton;
  final VoidCallback? onAddButtonPressed;

  const _AddRow({
    required this.titleAddButton,
    this.onAddButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onAddButtonPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      ),
      // icon: const Icon(Icons.add),
      // label: Text(widget.titleAddButton),
      // iconAlignment: IconAlignment.start,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.add),
          Flexible(child: Text(titleAddButton)),
        ],
      ),
    );
  }
}
