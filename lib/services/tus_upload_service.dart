import 'dart:developer';
import 'dart:io';

import 'package:cross_file/cross_file.dart' show XFile;
import 'package:path_provider/path_provider.dart';
import 'package:tus_client_dart/tus_client_dart.dart';

class TusUploadService {
  // A feltöltés progress
  double _progress = 0;

  // Becsült hátralévő idő
  Duration _estimate = const Duration();

  // A kiválasztott fájl
  XFile? _file;

  // TUS kliens a feltöltéshez
  TusClient? _client;

  // A feltöltött fájl URL-je
  Uri? _fileUrl;

  // TUS kliens url
  final String _tusClientUri = "http://192.168.50.102:1080/files/";

  double get progress => _progress;

  Duration get estimate => _estimate;

  Uri? get fileUrl => _fileUrl;

  void setFile(XFile? file) {
    _file = file;
    _progress = 0;
    _fileUrl = null;
  }

  Future<void> startUpload() async {
    if (_file == null) return;

    final tempDir = await getTemporaryDirectory();
    final tempDirectory = Directory('${tempDir.path}/${_file?.name}_uploads');
    if (!tempDirectory.existsSync()) {
      tempDirectory.createSync(recursive: true);
    }

    _client = TusClient(
      _file!,
      store: TusFileStore(tempDirectory),
      maxChunkSize: 512 * 1024 * 10,
    );

    try {
      await _client!.upload(
        onStart: (TusClient client, Duration? estimation) {},
        onComplete: () async {
          tempDirectory.deleteSync(recursive: true);
          _fileUrl = _client!.uploadUrl;
        },
        onProgress: (progress, estimate) {
          _progress = progress;
          _estimate = estimate;
        },
        uri: Uri.parse(_tusClientUri),
        // Átadható adatok -  metadata-ra megkötés Map<String, String>
        // TODO: erre a szerver oldalon kell figyelni, ha integer vagy más típusú adatot vár
        // metadata: {
        //   'category': 'set_off',
        //   'childId': '12',
        // },
        // Híváshoz tartozó fejlécek - pl.: bearer token, stb..
        // headers: {
        //   'Authorization': 'Bearer xyz',
        // },
        measureUploadSpeed: true,
      );
    } catch (e) {
      log('Feltöltésnél hiba történt: $e');
    }
  }

  Future<void> pauseUpload() async {
    await _client?.pauseUpload();
  }

  Future<void> cancelUpload() async {
    final result = await _client?.cancelUpload();
    if (result == true) {
      _progress = 0;
      _estimate = Duration();
    }
  }
}
