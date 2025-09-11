import 'package:flutter/material.dart';

enum ModalSize { big, small }

class BottomModal extends StatelessWidget {
  final ModalSize modalSize;
  final List<Widget> children;

  const BottomModal({
    required this.modalSize,
    required this.children,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SizedBox(
          height: (modalSize == ModalSize.small) ? 200 : 600,
          child: Center(
            child: SizedBox(
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
