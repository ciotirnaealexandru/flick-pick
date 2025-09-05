import 'package:flutter/material.dart';

class AddShowCard extends StatelessWidget {
  const AddShowCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.primary,
      ),
      clipBehavior: Clip.hardEdge,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          overlayColor: Colors.transparent,
          padding: EdgeInsets.zero,
        ),
        child: SizedBox(
          height: 150,
          width: 105,
          child: Center(
            child: Icon(
              Icons.add,
              size: 25,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),

        onPressed: () {
          Navigator.pushReplacementNamed(context, '/search');
        },
      ),
    );
  }
}
