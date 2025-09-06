import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final void Function(BuildContext) onPressed;

  const CustomIconButton({
    required this.text,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(context),
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(EdgeInsets.only(left: 15, right: 20)),
        backgroundColor: WidgetStatePropertyAll(
          Theme.of(context).colorScheme.primary,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 25, color: Theme.of(context).colorScheme.onPrimary),
          SizedBox(width: 8),
          Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
