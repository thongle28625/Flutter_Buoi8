import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'task_model.dart';

class FileService {
  static Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/tasks.json');
  }

  static Future<void> saveTasks(List<Task> tasks) async {
    final file = await _getFile();
    await file.writeAsString(jsonEncode(tasks));
  }

  static Future<List<Task>> loadTasks() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        String content = await file.readAsString();
        List<dynamic> jsonList = jsonDecode(content);
        return jsonList.map((e) => Task.fromJson(e)).toList();
      }
    } catch (e) {
      print("Lỗi đọc file: $e");
    }
    return [];
  }
}