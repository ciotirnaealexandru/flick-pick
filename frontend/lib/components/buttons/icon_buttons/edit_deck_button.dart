import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/components/border_text_field.dart';
import 'package:frontend/components/bottom_modal.dart';
import 'package:frontend/components/buttons/button_models/custom_filled_button.dart';
import 'package:frontend/components/buttons/button_models/custom_icon_button.dart';
import 'package:frontend/components/show_message.dart';
import 'package:http/http.dart' as http;

class EditDeckButton extends StatefulWidget {
  final int userId;
  final int deckId;
  final Future<void> Function() reloadFunction;

  const EditDeckButton({
    required this.userId,
    required this.deckId,
    required this.reloadFunction,
    super.key,
  });

  @override
  State<EditDeckButton> createState() => _EditDeckButtonState();
}

class _EditDeckButtonState extends State<EditDeckButton> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _changeNameOptions(BuildContext context) {
    // clear the text
    controller.clear();

    Future<void> changeNameFunction(deckName) async {
      final secureStorage = FlutterSecureStorage();
      final token = await secureStorage.read(
        key: dotenv.env['SECURE_STORAGE_SECRET']!,
      );

      final updateDeckResponse = await http.patch(
        Uri.parse(
          '${dotenv.env['API_URL']!}/user/deck/${widget.userId}/${widget.deckId}',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'deckName': deckName}),
      );

      await widget.reloadFunction();

      if (updateDeckResponse.statusCode == 200) {
        showMessage(context, "Changed deck name.");
      } else {
        print("Response body: ${updateDeckResponse.body}");

        final responseData = jsonDecode(updateDeckResponse.body);
        final message = responseData['message'] ?? 'Something went wrong.';

        showMessage(context, message);
      }

      Navigator.pop(context);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return BottomModal(
          modalSize: ModalSize.small,
          children: [
            BorderTextField(
              controller: controller,
              hintText: "Enter Deck Name",
              onSubmitted: (deckName) async {
                deckName = deckName.trim();
                await changeNameFunction(deckName);
              },
            ),
            SizedBox(height: 10),
            CustomFilledButton(
              onPressedFunction: () async {
                // get the text
                final deckName = controller.text.trim();

                // send a a request to the backend
                await changeNameFunction(deckName);
              },
              text: "Change Name",
            ),
          ],
        );
      },
    );
  }

  void _deleteDeckOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return BottomModal(
          modalSize: ModalSize.small,
          children: [
            Text(
              "Are you sure you want to delete this deck?",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            SizedBox(height: 10),
            CustomFilledButton(
              backgroundColor: Theme.of(context).colorScheme.error,
              onPressedFunction: () => Navigator.pop(context),
              text: "Delete",
            ),
          ],
        );
      },
    );
  }

  void _editDeckOptions(BuildContext context) {
    final rootContext = Navigator.of(context, rootNavigator: true).context;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return BottomModal(
          modalSize: ModalSize.small,
          children: [
            CustomFilledButton(
              onPressedFunction:
                  () => {
                    Navigator.pop(context),
                    Future.delayed(const Duration(milliseconds: 300), () {
                      _changeNameOptions(rootContext);
                    }),
                  },
              text: "Change Name",
            ),
            SizedBox(height: 10),
            CustomFilledButton(
              onPressedFunction:
                  () => {
                    Navigator.pop(context),
                    Future.delayed(const Duration(milliseconds: 300), () {
                      _deleteDeckOptions(rootContext);
                    }),
                  },
              text: "Delete Deck",
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      text: "Edit Deck",
      icon: Icons.edit_outlined,
      onPressed: _editDeckOptions,
    );
  }
}
