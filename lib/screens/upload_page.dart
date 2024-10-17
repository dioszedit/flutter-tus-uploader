import 'package:flutter/material.dart';

import '../services/tus_upload_service.dart';
import '../widgets/file_link.dart';
import '../widgets/file_upload_card.dart';
import '../widgets/progress_bar.dart';
import '../widgets/upload_controls.dart';

/// Fájl feltöltés oldal
class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  UploadPageState createState() => UploadPageState();
}

class UploadPageState extends State<UploadPage> {
  final TusUploadService _uploadService = TusUploadService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TUS kliens fájlfeltöltési demo'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Text(
                "Ez a demó a TUS klienst használ egy fájl feltöltésére.",
                style: TextStyle(fontSize: 18),
              ),
            ),
            FileUploadCard(onFilePicked: _uploadService.setFile),
            UploadControls(
              uploadService: _uploadService,
              onUploadStarted: () => setState(() {}),
            ),
            if (_uploadService.progress > 0)
              // Feltöltési sáv
              ProgressBar(
                progress: _uploadService.progress,
                estimate: _uploadService.estimate,
              ),
            if (_uploadService.progress > 0)
              ElevatedButton(
                onPressed: () async {
                  await _uploadService.cancelUpload();
                  setState(() {});
                },
                child: const Text("Mégsem"),
              ),
            FileLink(
              fileUrl: _uploadService.fileUrl,
              isComplete: _uploadService.progress == 100,
            ),
          ],
        ),
      ),
    );
  }
}
