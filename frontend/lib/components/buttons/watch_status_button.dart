import 'package:flutter/material.dart';

typedef WatchStatusCallback = void Function(String status);

class WatchStatusButton extends StatefulWidget {
  /// Values produced by this widget: "WATCHED", "WILL_WATCH", "NOT_WATCHED"
  final String? initialStatus;
  final WatchStatusCallback? onChanged;

  const WatchStatusButton({Key? key, this.initialStatus, this.onChanged})
    : super(key: key);

  @override
  State<WatchStatusButton> createState() => _WatchStatusButtonState();
}

class _WatchStatusButtonState extends State<WatchStatusButton> {
  String? selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.initialStatus;
  }

  void _handleSelection(String value) {
    final newStatus = value == 'REMOVE' ? null : value;
    setState(() => selectedStatus = newStatus);
    final outValue = newStatus ?? 'NOT_WATCHED';
    if (widget.onChanged != null) widget.onChanged!(outValue);
  }

  @override
  Widget build(BuildContext context) {
    final itemStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
      color: Theme.of(context).colorScheme.onPrimary,
    );

    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      child: SizedBox(
        width: 200,
        child: PopupMenuButton<String>(
          menuPadding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 200, height: 93),
          offset: const Offset(0, 0),
          color: Theme.of(context).colorScheme.primary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: _handleSelection,
          itemBuilder: (context) {
            // If nothing selected, show two "Add to ..." options
            if (selectedStatus == null) {
              return [
                PopupMenuItem<String>(
                  value: 'WATCHED',
                  padding: EdgeInsets.all(8),
                  height: 32,
                  child: SizedBox(
                    width: 200,
                    child: Center(
                      child: Text('Add to Watched', style: itemStyle),
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'WILL_WATCH',
                  padding: EdgeInsets.all(8),
                  height: 32,
                  child: SizedBox(
                    width: 200,
                    child: Center(
                      child: Text('Add to Future', style: itemStyle),
                    ),
                  ),
                ),
              ];
            }

            // If something selected, show the other option + remove
            final other =
                selectedStatus == 'WATCHED' ? 'WILL_WATCH' : 'WATCHED';
            final otherLabel =
                other == 'WATCHED' ? 'Add to Watched' : 'Add to Future';

            return [
              PopupMenuItem<String>(
                value: other,
                padding: EdgeInsets.all(8),
                child: SizedBox(
                  width: 200,
                  child: Center(child: Text(otherLabel, style: itemStyle)),
                ),
              ),
              PopupMenuItem<String>(
                value: 'REMOVE',
                padding: EdgeInsets.all(8),
                child: SizedBox(
                  width: 200,
                  child: Center(
                    child: Text(
                      'Remove Show',
                      style: itemStyle?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },

          // visible trigger button
          child: SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: null, // PopupMenuButton handles taps
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.primary,
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 5),
                ),
              ),
              child: Text(
                selectedStatus == null
                    ? 'Add to Watched'
                    : (selectedStatus == 'WATCHED' ? 'Watched' : 'Future'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
