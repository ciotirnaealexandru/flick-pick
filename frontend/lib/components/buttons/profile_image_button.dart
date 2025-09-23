import 'package:flutter/material.dart';
import 'package:frontend/components/bottom_modal.dart';
import 'package:frontend/components/buttons/button_models/custom_transparent_button.dart';

class ProfileImageButton extends StatefulWidget {
  final String profileImageColor;
  final List<String> profileImageColorOptions;
  final Future<void> Function(String) changeProfileImageColor;

  const ProfileImageButton({
    required this.profileImageColor,
    required this.profileImageColorOptions,
    required this.changeProfileImageColor,
    super.key,
  });

  @override
  State<ProfileImageButton> createState() => _ProfileImageButtonState();
}

class _ProfileImageButtonState extends State<ProfileImageButton> {
  void _openProfileImageColorOptions(BuildContext context) {
    FocusScope.of(context).unfocus();

    Future.delayed(const Duration(milliseconds: 200), () {
      if (!context.mounted) return;
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return BottomModal(
            modalSize: ModalSize.small,
            children: [
              Text(
                "Choose your profile color :",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 15,
                children:
                    widget.profileImageColorOptions.map((option) {
                      return CustomTransparentButton(
                        onPressed: () async {
                          await widget.changeProfileImageColor(option);
                          if (!context.mounted) return;
                          Navigator.pop(context);
                        },
                        child: CircleAvatar(
                          radius: 36,
                          backgroundImage: AssetImage(
                            'assets/images/${option.toLowerCase()}.jpeg',
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomTransparentButton(
      onPressed: () => _openProfileImageColorOptions(context),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.onPrimary,
            width: 3.0,
          ),
        ),
        child: CircleAvatar(
          radius: 70,
          backgroundImage: AssetImage(
            'assets/images/${widget.profileImageColor.toLowerCase()}.jpeg',
          ),
        ),
      ),
    );
  }
}
