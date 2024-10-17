import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';

import '../services/file_picker_service.dart';

/// Fájl feltöltés kártya
class FileUploadCard extends StatelessWidget {
  final Function(XFile?) onFilePicked;

  const FileUploadCard({super.key, required this.onFilePicked});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Card(
        color: Colors.blue,
        child: InkWell(
          onTap: () async {
            final file = await FilePickerService.pickFile();
            onFilePicked(file);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Fájl feltöltése",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
                Icon(
                  Icons.cloud_upload,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
