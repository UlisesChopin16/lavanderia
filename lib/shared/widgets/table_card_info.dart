import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lavanderia/app/theme/color_row_theme.dart';
import 'package:lavanderia/app/theme/theme_app.dart';
import 'package:lavanderia/features/configuracion_empresa/presentation/views/view_model/configuracion_empresa_view_model.dart';

class TableCardInfo extends ConsumerStatefulWidget {
  final String titleAddButton;
  final VoidCallback? onAddButtonPressed;
  final DataTable dataTable;

  /// Callback to be called when the search text changes
  /// The callback receives the search text as a parameter
  final ValueChanged<String>? onSearchChanged;

  /// Filters to be displayed above the table
  /// Each filter should be a widget that can be used to filter the data in the table
  final List<Widget> filters;

  /// Actions to be displayed in the table
  /// Each action should be a [DataAction] with a callback that receives the index of the row
  /// where the action was triggered.
  /// If no actions are provided, the table will not display an actions column.
  /// If actions are provided, they will be displayed in the last column of the table.
  /// The actions will be displayed as buttons in each row.
  /// If the number of actions is greater than 2, a menu button will be displayed instead of individual buttons.
  final List<DataAction> actions;

  const TableCardInfo({
    super.key,
    required this.titleAddButton,
    required this.dataTable,
    this.onAddButtonPressed,
    this.onSearchChanged,
    this.filters = const [],
    this.actions = const [],
  });

  @override
  ConsumerState<TableCardInfo> createState() => _TableCardInfoState();
}

class _TableCardInfoState extends ConsumerState<TableCardInfo> {
  int sortColumnIndex = 1;
  bool sortAscending = false;
  List<DataAction> get actions => widget.actions.where((action) => !action.isNotEnabled).toList();
  DataTable get dataTable => widget.dataTable;
  List<DataColumn> get columns {
    List<DataColumn> columnas = dataTable.columns.map(_buildDataColumn).toList();
    if (actions.isNotEmpty) {
      columnas.add(
        const DataColumn(
          label: Text('Acciones'),
          headingRowAlignment: MainAxisAlignment.center,
        ),
      );
    }
    return columnas;
  }

  List<DataRow> get rows => _buildDataRows(dataTable.rows);

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
    final blockUI = ref.watch(
      configuracionEmpresaViewModelProvider.select((value) => value.blockUI),
    );
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 15,
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
                FilledButton(
                  onPressed: widget.onAddButtonPressed,
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
                      Text(widget.titleAddButton),
                    ],
                  ),
                ),
            ],
          ),
          Wrap(
            alignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.end,
            runAlignment: WrapAlignment.end,
            spacing: 10,
            runSpacing: 10,
            children: [
              ...widget.filters,
            ],
          ),
          SingleChildScrollView(
            child: newDataTable,
          ),
        ],
      ),
    );
  }

  DataColumn _buildDataColumn(DataColumn column) {
    return DataColumn(
      headingRowAlignment: MainAxisAlignment.center,
      label: Center(child: column.label),
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
    List<DataRow> newRows = List.from(dataTable.rows);
    for (var i = 0; i < rows.length; i++) {
      newRows[i] = _buildDataRow(rows[i], i);
    }
    return newRows;
  }

  DataRow _buildDataRow(DataRow row, int index) {
    final colorRowTheme = Theme.of(context).extension<ColorRowTheme>();
    List<DataCell> cells = row.cells.map((cell) => _buildDataCell(cell, index)).toList();
    // for (var i = 0; i < cells.length; i++) {
    //   cells.add(
    //     DataCell(
    //       _ActionsButtons(
    //         index: index,
    //         actions: actions,
    //       ),
    //     ),
    //   );
    // }
    if (actions.isNotEmpty) {
      cells.add(
        DataCell(
          _ActionsButtons(
            index: index,
            actions: actions,
          ),
        ),
      );
    }
    return DataRow(
      color: WidgetStatePropertyAll(
        colorRowTheme?.getColor(index + 1),
      ),
      cells: cells,
      key: row.key,
      onSelectChanged: row.onSelectChanged,
      mouseCursor: row.mouseCursor,
      selected: row.selected,
      onLongPress: row.onLongPress,
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

class DataAction {
  final ValueChanged<int> callbackIndex;
  final IconData icon;
  final String tooltip;
  final bool isNotEnabled;

  const DataAction({
    required this.callbackIndex,
    required this.icon,
    required this.isNotEnabled,
    this.tooltip = '',
  });

  // @override
  // Widget build(BuildContext context) {
  //   return FloatingActionButton.small(
  //     heroTag: null,
  //     tooltip: tooltip,
  //     backgroundColor: color,
  //     onPressed: () => callbackIndex.call(0),
  //     child: Icon(icon, color: color),
  //   );
  // }
}

class _ActionsButtons extends StatefulWidget {
  final int index;
  final List<DataAction> actions;
  const _ActionsButtons({
    required this.index,
    required this.actions,
  });

  @override
  State<_ActionsButtons> createState() => _ActionsButtonsState();
}

class _ActionsButtonsState extends State<_ActionsButtons> {
  final globalButtonKey = GlobalKey();
  static const colors = [
    Colors.redAccent,
    Colors.greenAccent,
    Colors.blueAccent,
    Colors.deepPurpleAccent,
    Colors.yellowAccent,
  ];
  int get index => widget.index;
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
                onPressed: () => actions[i].callbackIndex.call(widget.index),
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
              actions[i].callbackIndex.call(widget.index);
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }
}
