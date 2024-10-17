import 'package:flutter/material.dart';

/// Folyamatjelző
class ProgressBar extends StatelessWidget {
  final double progress;
  final Duration estimate;
  const ProgressBar(
      {super.key, required this.progress, required this.estimate});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(1),
          width: double.infinity,
          child: Text(" "),
        ),
        // A feltöltési sáv - zöld a folyamatban lévő rész
        FractionallySizedBox(
          widthFactor: progress / 100,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(1),
            // Nincs szöveg, csak a százalék jelzése
            child: const Text(" "),
          ),
        ),
        // A százalék és az idő kijelzése
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(1),
            width: double.infinity,
            child: Text("Feltöltve: ${progress.toStringAsFixed(1)}%"),
          ),
        ),
      ],
    );
  }
}
