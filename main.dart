import 'package:flutter/material.dart';
import 'task_model.dart';
import 'file_service.dart';
import 'notification_service.dart';

// SỬA: Bỏ chữ 'const' ở đây vì TodoListScreen không phải là const widget
void main() => runApp(MaterialApp(home: TodoListScreen(), debugShowCheckedModeBanner: false,));

class TodoListScreen extends StatefulWidget {
  // SỬA: Thêm key để hết cảnh báo vàng
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Task> _tasks = [];
  final _notiService = NotificationService();

  @override
  void initState() {
    super.initState();
    // Khởi tạo thông báo và load dữ liệu
    _initApp();
  }

  Future<void> _initApp() async {
    await _notiService.init();
    final loadedTasks = await FileService.loadTasks();
    setState(() {
      _tasks = loadedTasks;
    });
  }

  void _handleTaskComplete(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Xác nhận"),
        content: const Text("Xác nhận nhiệm vụ này đã hoàn thành?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Không"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _tasks[index].isCompleted = true;
                FileService.saveTasks(_tasks);
                int count = _tasks.where((t) => t.isCompleted).length;
                // Gọi hàm từ notification_service.dart đã sửa
                _notiService.showTaskNotification(count);
              });
              Navigator.pop(ctx);
            },
            child: const Text("Có"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nhiệm vụ mỗi ngày"),
        actions: const [Icon(Icons.calendar_today_outlined), SizedBox(width: 15)],
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, i) => Card(
          child: ListTile(
            leading: Checkbox(
              value: _tasks[i].isCompleted,
              onChanged: (_) => _handleTaskComplete(i),
            ),
            title: Text(_tasks[i].title),
            subtitle: Text("Nhắc lúc ${_tasks[i].reminderTime}"),
            trailing: const Icon(Icons.notifications_active_outlined),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (c) => const AddTaskScreen()),
          );
          if (result != null && result is Task) {
            setState(() {
              _tasks.add(result);
              FileService.saveTasks(_tasks);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameCtrl = TextEditingController();
    final timeCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Thêm nhiệm vụ mới")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Tên nhiệm vụ")),
            TextField(controller: timeCtrl, decoration: const InputDecoration(labelText: "Giờ nhắc")),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (nameCtrl.text.isNotEmpty) {
                  Navigator.pop(
                    context,
                    Task(title: nameCtrl.text, reminderTime: timeCtrl.text),
                  );
                }
              },
              child: const Text("Lưu nhiệm vụ"),
            ),
          ],
        ),
      ),
    );
  }
}