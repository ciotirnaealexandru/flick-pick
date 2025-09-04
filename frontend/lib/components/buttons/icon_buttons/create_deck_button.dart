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

class CreateDeckButton extends StatefulWidget {
  final int userId;

  const CreateDeckButton({required this.userId, super.key});

  @override
  State<CreateDeckButton> createState() => _CreateDeckButtonState();
}

class _CreateDeckButtonState extends State<CreateDeckButton> {
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

  Future<void> createDeckFunction(deckName) async {
    final secureStorage = FlutterSecureStorage();
    final token = await secureStorage.read(
      key: dotenv.env['SECURE_STORAGE_SECRET']!,
    );

    final createDeckResponse = await http.post(
      Uri.parse('${dotenv.env['API_URL']!}/user/deck/${widget.userId}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'deckName': deckName}),
    );

    if (createDeckResponse.statusCode == 200) {
      showMessage(context, "Deck successfully created.");
    } else {
      print("Response body: ${createDeckResponse.body}");

      final responseData = jsonDecode(createDeckResponse.body);
      final message = responseData['message'] ?? 'Something went wrong.';

      showMessage(context, message);
    }

    Navigator.pop(context);
  }

  void _openCreateDeckOptions(BuildContext context) {
    // clear the text
    controller.clear();

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
                await createDeckFunction(deckName);
              },
            ),
            SizedBox(height: 10),
            CustomFilledButton(
              onPressed: () async {
                // get the text
                final deckName = controller.text.trim();

                // send a a request to the backend
                await createDeckFunction(deckName);
              },
              text: "Create Deck",
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      text: "Create Deck",
      icon: Icons.add,
      onPressed: _openCreateDeckOptions,
    );
  }
}
