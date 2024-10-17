import 'package:cross_file/cross_file.dart' show XFile;
import 'package:file_picker/file_picker.dart';

/// Fájl kiválasztás szolgáltatás
class FilePickerService {
  static Future<XFile?> pickFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final chosenFile = result.files.first;
      if (chosenFile.path != null) {
        // Android, iOS esetén a path nem lehet null
        return XFile(chosenFile.path!);
      }
      return null;
    }
  }
}
