import 'package:flutter/material.dart';
import 'main.dart'; // Import để lấy cái reminderList

class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lịch nhắc học")),
      body: reminderList.isEmpty
          ? const Center(child: Text("Chưa có lịch nhắc nào!"))
          : ListView.builder(
        itemCount: reminderList.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: const Icon(Icons.alarm, color: Colors.blue),
              title: Text("${reminderList[index]['word']} : ${reminderList[index]['meaning']}"),
              subtitle: Text("Thời gian: ${reminderList[index]['time']}"),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  // Thêm chức năng xóa nếu muốn
                },
              ),
            ),
          );
        },
      ),
    );
  }
}