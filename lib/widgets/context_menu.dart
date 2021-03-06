import 'package:flutter/material.dart';

class ContextMenu extends StatelessWidget {
  final Widget child;
  final List<ContextMenuEntry> entries;
  final bool openOnSecondary;
  final bool openOnLong;

  const ContextMenu({
    required this.child,
    required this.entries,
    this.openOnSecondary = true,
    this.openOnLong = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: openOnLong
          ? (details) => _openContextMenu(context, details.globalPosition)
          : null,
      onSecondaryTapUp: openOnSecondary
          ? (details) => _openContextMenu(context, details.globalPosition)
          : null,
      behavior: HitTestBehavior.translucent,
      child: child,
    );
  }

  void _openContextMenu(BuildContext context, Offset position) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx,
        position.dy,
      ),
      items: entries
          .map(
            (e) => _ContextMenuEntry(
              id: e.id,
              icon: e.icon,
              text: e.text,
              onTap: e.onTap,
            ),
          )
          .toList(),
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    );
  }
}

class ContextMenuEntry {
  final String id;
  final Widget icon;
  final Widget text;
  final VoidCallback onTap;

  const ContextMenuEntry({
    required this.id,
    required this.icon,
    required this.text,
    required this.onTap,
  });
}

class _ContextMenuEntry extends PopupMenuEntry<String> {
  final String id;
  final Widget icon;
  final Widget text;
  final VoidCallback onTap;

  const _ContextMenuEntry({
    required this.id,
    required this.icon,
    required this.text,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  _ContextMenuEntryState createState() => _ContextMenuEntryState();

  @override
  double get height => 40;

  @override
  bool represents(String? value) => id == value;
}

class _ContextMenuEntryState extends State<_ContextMenuEntry> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: 320,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          widget.onTap();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              IconTheme.merge(
                data: IconThemeData(
                  size: 20,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
                child: widget.icon,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
                  child: widget.text,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
