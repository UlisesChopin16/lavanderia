import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lavanderia/app/theme/color_row_theme.dart';
import 'package:lavanderia/app/theme/theme_app.dart';
import 'package:lavanderia/core/utils/constants_manager.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/views/view_model/configuracion_empresa_view_model.dart';

import 'button_clear_filters.dart';

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

  /// If true, will display a button to clear filters
  final bool haveFilters;

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
  late int sortColumnIndex = widget.sortColumnIndex;
  bool sortAscending = true;
  // List<DataAction> get actions => widget.actions.where((action) => !action.isNotEnabled).toList();
  bool get showActions => widget.showActions;
  List<DataColumn> get columns {
    List<DataColumn> columnas = widget.columns.map(_buildDataColumn).toList();
    if (showActions) {
      columnas.add(
        const DataColumn(
          label: Text('Acciones'),
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
    // final isDark = Theme.of(context).brightness == Brightness.dark;
    // final color = isDark ? Colors.grey[800] : Colors.grey[200];
    return DataTable(
      sortColumnIndex: sortColumnIndex,
      sortAscending: sortAscending,
      // dataRowColor: WidgetStateProperty.resolveAs(WidgetStatePropertyAll(color), {WidgetState.hovered}),
      columns: columns,
      rows: rows,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmall = width <= ConstantsManager.mediumScreen;
    final blockUI = ref.watch(
      configuracionEmpresaViewModelProvider.select((value) => value.blockUI),
    );
    // if (rows.isEmpty && !widget.haveFilters) {
    //   return Padding(
    //     padding: const EdgeInsets.all(40.0),
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       spacing: 20,
    //       children: [
    //         Text(
    //           'No hay datos disponibles\nAgregue un nuevo elemento',
    //           textAlign: TextAlign.center,
    //           style: Theme.of(context).textTheme.titleMedium,
    //         ),
    //         if (!blockUI)
    //           _AddRow(
    //             titleAddButton: widget.titleAddButton,
    //             onAddButtonPressed: widget.onAddButtonPressed,
    //           ),
    //       ],
    //     ),
    //   );
    // }
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOutCubic,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
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
            ),
            const Divider(),
            const Gap(0),
            Wrap(
              alignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.end,
              runAlignment: WrapAlignment.end,
              spacing: 10,
              runSpacing: 10,
              children: [
                if (widget.haveFilters)
                  ButtonClearFilters(
                    onPressed: widget.onClearFilters,
                  ),
                ...widget.filters,
                // if (widget.onSortChange != null)
                //   SortButton(
                //     isAscending: sortAscending,
                //     onSortChange: () {
                //       setState(() {
                //         sortAscending = !sortAscending;
                //       });
                //       widget.onSortChange?.call(sortAscending);
                //     },
                //   ),
              ],
            ),
            if (isSmall) widget.smallView else newDataTable,
            if (widget.rows.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(
                  'No hay datos disponibles\nAgregue un nuevo elemento',
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
      onSort: (columnIndex, ascending) {
        setState(() {
          sortColumnIndex = columnIndex;
          sortAscending = ascending;
        });
        column.onSort?.call(columnIndex, ascending);
      },
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

class DataAction {
  final VoidCallback callbackIndex;
  final IconData icon;
  final String tooltip;
  final bool isNotEnabled;

  const DataAction({
    required this.callbackIndex,
    required this.icon,
    required this.isNotEnabled,
    this.tooltip = '',
  });
}

class ActionsButtons extends StatefulWidget {
  final List<DataAction> actions;
  const ActionsButtons({
    super.key,
    required this.actions,
  });

  @override
  State<ActionsButtons> createState() => _ActionsButtonsState();
}

class _ActionsButtonsState extends State<ActionsButtons> {
  final globalButtonKey = GlobalKey();
  static const colors = [
    Colors.redAccent,
    Colors.greenAccent,
    Colors.blueAccent,
    Colors.deepPurpleAccent,
    Colors.yellowAccent,
  ];
  // int get index => widget.index;
  List<DataAction> get actions => widget.actions.where((action) => !action.isNotEnabled).toList();
  bool get isTooLong => actions.length >= 3;

  Widget get rowActions {
    final brightness = Theme.of(context).colorScheme.brightness;
    return Center(
      child: Row(
        spacing: 5,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ...List.generate(actions.length, (i) {
            final color = colors[i];
            final seedColor = ThemeApp.getColorScheme(
              color,
              brightness == Brightness.dark,
            );
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: FloatingActionButton.small(
                heroTag: null,
                tooltip: actions[i].tooltip,
                backgroundColor: seedColor.primary,
                foregroundColor: seedColor.onPrimary,
                onPressed: () => actions[i].callbackIndex.call(),
                child: Icon(actions[i].icon),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget get actionsButton {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final onPrimaryColor = Theme.of(context).colorScheme.onPrimary;
    return Center(
      child: FloatingActionButton.small(
        key: globalButtonKey,
        heroTag: null,
        tooltip: 'Menu de acciones',
        backgroundColor: primaryColor,
        foregroundColor: onPrimaryColor,
        onPressed: () => showPopupMenu(),
        child: const Icon(Icons.menu),
      ),
    );
  }

  Widget get actionsCell => isTooLong ? actionsButton : rowActions;

  @override
  Widget build(BuildContext context) {
    // PopupMenuButton
    return actionsCell;
  }

  void showPopupMenu() async {
    final RenderBox button = globalButtonKey.currentContext!.findRenderObject()! as RenderBox;
    final RenderBox overlay = Navigator.of(context, rootNavigator: true)
        .overlay!
        .context
        .findRenderObject()! as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    await showMenu(
      context: context,
      position: position,
      items: List.generate(
        actions.length,
        (i) => PopupMenuItem(
          value: actions[i],
          child: ListTile(
            leading: Icon(actions[i].icon, color: colors[i]),
            title: Text(actions[i].tooltip),
            onTap: () {
              actions[i].callbackIndex.call();
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }
}
