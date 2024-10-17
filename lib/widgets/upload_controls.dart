import 'package:flutter/material.dart';

import '../services/tus_upload_service.dart';

/// Fájl feltöltés vezérlők
class UploadControls extends StatelessWidget {
  final TusUploadService uploadService;
  final VoidCallback onUploadStarted;

  const UploadControls({
    super.key,
    required this.uploadService,
    required this.onUploadStarted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              onPressed:
                  uploadService.progress > 0 && uploadService.progress < 100
                      ? null
                      : _handleUpload,
              child: Text(
                  uploadService.progress > 0 && uploadService.progress < 100
                      ? "Folytatás"
                      : "Feltöltés"),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed:
                  uploadService.progress > 0 && uploadService.progress < 100
                      ? _handlePause
                      : null,
              child: const Text("Szüneteltetés"),
            ),
          ),
        ],
      ),
    );
  }

  /// Fájl feltöltésének indítása
  void _handleUpload() async {
    await uploadService.startUpload();
    onUploadStarted();
  }

  /// Fájl feltöltésének szüneteltetése
  void _handlePause() async {
    await uploadService.pauseUpload();
    onUploadStarted(); // Ezt hívjuk, hogy frissüljön a UI a szüneteltetés után is
  }
}
