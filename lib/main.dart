import 'dart:io';

import 'package:cross_file/cross_file.dart' show XFile;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tus_client_dart/tus_client_dart.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TUS Client Upload Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: UploadPage(),
    );
  }
}

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  UploadPageState createState() => UploadPageState();
}

class UploadPageState extends State<UploadPage> {
  double _progress = 0;
  Duration _estimate = const Duration();
  XFile? _file;
  TusClient? _client;
  Uri? _fileUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TUS Client Upload Demo'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Text(
                "This demo uses TUS client to upload a file",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: Card(
                color: Colors.teal,
                child: InkWell(
                  onTap: () async {
                    _file =
                    await _getXFile(await FilePicker.platform.pickFiles());
                    setState(() {
                      _progress = 0;
                      _fileUrl = null;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: const Column(
                      children: <Widget>[
                        Icon(Icons.cloud_upload, color: Colors.white, size: 60),
                        Text(
                          "Upload a file",
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _file == null
                          ? null
                          : () async {
                        final tempDir = await getTemporaryDirectory();
                        final tempDirectory = Directory(
                            '${tempDir.path}/${_file?.name}_uploads');
                        if (!tempDirectory.existsSync()) {
                          tempDirectory.createSync(recursive: true);
                        }

                        // Create a client
                        if (kDebugMode) {
                          print("Create a client");
                        }
                        _client = TusClient(
                          _file!,
                          store: TusFileStore(tempDirectory),
                          maxChunkSize: 512 * 1024 * 10,
                        );

                        if (kDebugMode) {
                          print("Starting upload");
                        }
                        await _client!.upload(
                          onStart:
                              (TusClient client, Duration? estimation) {
                            if (kDebugMode) {
                              print(estimation);
                            }
                          },
                          onComplete: () async {
                            if (kDebugMode) {
                              print("Completed!");
                            }
                            tempDirectory.deleteSync(recursive: true);
                            setState(() => _fileUrl = _client!.uploadUrl);
                          },
                          onProgress: (progress, estimate) {
                            if (kDebugMode) {
                              print("Progress: $progress");
                            }
                            if (kDebugMode) {
                              print('Estimate: $estimate');
                            }
                            setState(() {
                              _progress = progress;
                              _estimate = estimate;
                            });
                          },
                          uri: Uri.parse(
                              "http://192.168.2.67:1080/files/"),
                          metadata: {
                            'testMetaData': 'testMetaData',
                            'testMetaData2': 'testMetaData2',
                          },
                          headers: {
                            'testHeaders': 'testHeaders',
                            'testHeaders2': 'testHeaders2',
                          },
                          measureUploadSpeed: true,
                        );
                      },
                      child: const Text("Upload"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _progress == 0
                          ? null
                          : () async {
                        _client!.pauseUpload();
                      },
                      child: Text("Pause"),
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(1),
                  color: Colors.grey,
                  width: double.infinity,
                  child: Text(" "),
                ),
                FractionallySizedBox(
                  widthFactor: _progress / 100,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(1),
                    color: Colors.green,
                    child: const Text(" "),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(1),
                  width: double.infinity,
                  child: Text(
                      "Progress: ${_progress.toStringAsFixed(1)}%, estimated time: ${_printDuration(_estimate)}"),
                ),
              ],
            ),
            if (_progress > 0)
              ElevatedButton(
                onPressed: () async {
                  final result = await _client!.cancelUpload();

                  if (result) {
                    setState(() {
                      _progress = 0;
                      _estimate = Duration();
                    });
                  }
                },
                child: const Text("Cancel"),
              ),
            GestureDetector(
              onTap: _progress != 100
                  ? null
                  : () async {
                await launchUrl(_fileUrl!);
              },
              child: Container(
                color: _progress == 100 ? Colors.green : Colors.grey,
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(8.0),
                child:
                Text(_progress == 100 ? "Link to view:\n $_fileUrl" : "-"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  /// Copy file to temporary directory before uploading
  Future<XFile> _getXFile(FilePickerResult? result) async {
    if (result != null) {
      final chosenFile = result.files.first;
      if (chosenFile.path != null) {
        // Android, iOS, Desktop
        return XFile(chosenFile.path!);
      } else {
        // Web
        return XFile.fromData(
          chosenFile.bytes!,
          name: chosenFile.name,
        );
      }
    }
    return XFile('');
  }
}
