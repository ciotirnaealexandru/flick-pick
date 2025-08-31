import 'package:flutter/material.dart';

typedef WatchStatusCallback = void Function(String status);

class WatchStatusButton extends StatefulWidget {
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
    final newStatus = value == 'REMOVE' ? 'NOT_WATCHED' : value;
    setState(() => selectedStatus = newStatus);
    if (widget.onChanged != null) widget.onChanged!(newStatus);
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
            borderRadius: BorderRadius.circular(16),
          ),
          onSelected: _handleSelection,
          itemBuilder: (context) {
            if (selectedStatus == "NOT_WATCHED") {
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
            } else if (selectedStatus == "WATCHED") {
              return [
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
                PopupMenuItem<String>(
                  value: 'NOT_WATCHED',
                  padding: EdgeInsets.all(8),
                  height: 32,
                  child: SizedBox(
                    width: 200,
                    child: Center(
                      child: Text(
                        'Remove Show',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ),
                ),
              ];
            } else {
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
                  value: 'NOT_WATCHED',
                  padding: EdgeInsets.all(8),
                  height: 32,
                  child: SizedBox(
                    width: 200,
                    child: Center(
                      child: Text(
                        'Remove Show',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ),
                ),
              ];
            }
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
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 5),
                ),
              ),
              child: Text(
                selectedStatus == "NOT_WATCHED"
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
