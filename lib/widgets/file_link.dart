import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Fájl link megjelenítése feltöltés után
class FileLink extends StatelessWidget {
  final bool isComplete;
  final Uri? fileUrl;

  const FileLink({super.key, required this.isComplete, this.fileUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: !isComplete
          ? null
          : () async {
              // Fájl megnyitása a böngészőben
              await launchUrl(fileUrl!);
            },
      child: isComplete
          ? Container(
              decoration: BoxDecoration(
                color: Colors.green,
                border: Border.all(
                  color: isComplete ? Colors.green : Colors.grey,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(8.0),
              child: Text(
                "Feltöltött fájl linkje:\n $fileUrl",
                style: TextStyle(color: Colors.white),
              ),
            )
          : Container(),
    );
  }
}
