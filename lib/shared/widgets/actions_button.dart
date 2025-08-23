import 'package:flutter/material.dart';
import 'package:lavanderia/app/theme/theme_app.dart';

class ActionsButtons extends StatefulWidget {
  const ActionsButtons({
    super.key,
    required this.actions,
    required this.isSmall,
  });

  final bool isSmall;
  final List<DataAction> actions;

  @override
  State<ActionsButtons> createState() => _ActionsButtonsState();
}

class _ActionsButtonsState extends State<ActionsButtons> {
  final globalButtonKey = GlobalKey();

  // int get index => widget.index;
  List<DataAction> get actions => widget.actions.where((action) => !action.isNotEnabled).toList();
  bool get isTooLong => actions.length >= 3;
  bool get isSmall => widget.isSmall;

  Widget get rowActions {
    final brightness = Theme.of(context).colorScheme.brightness;
    return Center(
      child: Row(
        spacing: 5,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ...List.generate(
            actions.length,
            (i) {
              final action = actions[i];
              final color = action.color;
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
            },
          ),
        ],
      ),
    );
  }

  Widget get actionsButton {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final onPrimaryColor = Theme.of(context).colorScheme.onPrimary;
    return FloatingActionButton.small(
      key: globalButtonKey,
      heroTag: null,
      tooltip: 'Menu de acciones',
      backgroundColor: primaryColor,
      foregroundColor: onPrimaryColor,
      onPressed: () => showPopupMenu(),
      child: const Icon(Icons.menu),
    );
  }

  Widget get actionsCell => isSmall || isTooLong ? actionsButton : rowActions;

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
        (i) {
          return PopupMenuItem(
            value: actions[i],
            child: ListTile(
              leading: Icon(actions[i].icon, color: actions[i].color),
              title: Text(actions[i].tooltip),
              onTap: () {
                actions[i].callbackIndex.call();
                Navigator.of(context).pop();
              },
            ),
          );
        },
      ),
    );
  }
}

class DataAction {
  final VoidCallback callbackIndex;
  final IconData icon;
  final Color color;
  final String tooltip;
  final bool isNotEnabled;

  const DataAction({
    required this.callbackIndex,
    required this.icon,
    required this.isNotEnabled,
    required this.color,
    this.tooltip = '',
  });
}