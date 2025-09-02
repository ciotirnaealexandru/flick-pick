import 'package:flutter/material.dart';
import 'package:frontend/components/buttons/filled_button.dart';

class CreateDeckButton extends StatefulWidget {
  const CreateDeckButton({super.key});

  @override
  State<CreateDeckButton> createState() => _CreateDeckButtonState();
}

class _CreateDeckButtonState extends State<CreateDeckButton> {
  void _openCreateDeckOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(
                  context,
                ).viewInsets.bottom, // pushes up on keyboard
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),

            child: SizedBox(
              height: 200,
              child: Center(
                child: SizedBox(
                  width: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      SizedBox(
                        height: 50,
                        child: TextField(
                          // onSubmitted: () {},
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            hintText: "Enter Deck Name",
                            hintStyle: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.onPrimary,
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.onPrimary,
                                width: 1.5,
                              ),
                            ),
                          ),
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            decoration: TextDecoration.none,
                            decorationThickness: 0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      CustomFilledButton(
                        onPressedFunction: () => Navigator.pop(context),
                        text: "Create Deck",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => {_openCreateDeckOptions(context)},
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
