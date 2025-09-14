import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/components/bottom_modal.dart';
import 'package:frontend/components/buttons/button_models/custom_icon_button.dart';
import 'package:frontend/components/buttons/button_models/custom_transparent_button.dart';
import 'package:frontend/services/env_service.dart';
import 'package:http/http.dart' as http;

class Genre {
  final String genreName;
  final int genreId;

  Genre({required this.genreName, required this.genreId});
}

class GenreButton extends StatefulWidget {
  final Genre genre;
  final Future<void> Function(Genre) changeGenre;

  const GenreButton({
    required this.genre,
    required this.changeGenre,
    super.key,
  });

  @override
  State<GenreButton> createState() => _GenreButtonState();
}

class _GenreButtonState extends State<GenreButton> {
  List<Genre>? genreOptions;
  bool finishedLoading = false;

  @override
  void initState() {
    super.initState();
    getGenres();
  }

  Future<void> getGenres() async {
    final response = await http.get(
      Uri.parse('${EnvConfig.apiUrl}/show/genres'),
      headers: {'Content-Type': 'application/json'},
    );

    final List<dynamic> genresJson = json.decode(response.body);

    final genreOriginalOptions =
        genresJson
            .map(
              (json) =>
                  Genre(genreName: json['genreName'], genreId: json['genreId']),
            )
            .toList();

    final limitedGenres =
        genreOriginalOptions.length > 12
            ? genreOriginalOptions.sublist(0, 12)
            : genreOriginalOptions;

    setState(() {
      genreOptions = [Genre(genreName: "All", genreId: 0), ...limitedGenres];
      finishedLoading = true;
    });
  }

  void _openGenreOptions(BuildContext context) {
    if (!finishedLoading) return;

    FocusScope.of(context).unfocus();

    Future.delayed(const Duration(milliseconds: 200), () {
      if (!context.mounted) return;
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return BottomModal(
            modalSize: ModalSize.big,
            children:
                genreOptions!.map((option) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: CustomTransparentButton(
                      onPressed: () async {
                        await widget.changeGenre(option);
                        if (!context.mounted) return;
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration:
                            widget.genre.genreId == option.genreId
                                ? BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                      width: 2.5,
                                    ),
                                  ),
                                )
                                : null,
                        child: Text(
                          option.genreName,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  );
                }).toList(),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      text: "Genre",
      icon: Icons.dashboard_outlined,
      onPressed: _openGenreOptions,
    );
  }
}
