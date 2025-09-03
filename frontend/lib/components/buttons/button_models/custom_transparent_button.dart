import 'package:flutter/material.dart';

class CustomTransparentButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  const CustomTransparentButton({
    required this.child,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashFactory: NoSplash.splashFactory,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          overlayColor: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 0),
        ),
        child: child,
      ),
    );
  }
}
