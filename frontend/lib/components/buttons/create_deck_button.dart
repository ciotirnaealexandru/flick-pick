import 'package:flutter/material.dart';

class CreateDeckButton extends StatefulWidget {
  const CreateDeckButton({super.key});

  @override
  State<CreateDeckButton> createState() => _CreateDeckButtonState();
}

class _CreateDeckButtonState extends State<CreateDeckButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => {},
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(EdgeInsets.only(left: 15, right: 20)),
      ),
      child: Row(
        children: [
          Icon(Icons.add, size: 25),
          SizedBox(width: 6),
          Text(
            "Create Deck",
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
