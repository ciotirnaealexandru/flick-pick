import 'package:flutter/material.dart';
import 'package:frontend/components/buttons/button_models/custom_filled_button.dart';

class AddToWatchlistButton extends StatelessWidget {
  const AddToWatchlistButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomFilledButton(
      onPressedFunction:
          () => Navigator.pushNamed(context, "/add_to_watchlist"),
      text: "Add to Watchlist",
    );
  }
}
