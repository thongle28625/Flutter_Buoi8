import 'package:flutter/material.dart';
import 'main.dart'; // Import để lấy cái list globalVocabulary

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int correct = 0;
  int wrong = 0;
  int currentIndex = 0; // Biến này để biết đang ở câu thứ mấy

  void checkAnswer(bool userChoice) {
    // 1. Lấy dữ liệu câu hỏi hiện tại từ List chung
    bool actualResult = true; // Ở đây mày có thể chế logic:
    // Ví dụ: thỉnh thoảng hiện nghĩa sai để người dùng chọn "Sai"
    // Nhưng để đơn giản, cứ cho là hiện đúng nghĩa, chọn Đúng là cộng điểm.

    setState(() {
      if (userChoice == true) {
        correct++;
      } else {
        wrong++;
      }

      // 2. Kiểm tra xem đã hết danh sách từ chưa
      if (currentIndex < reminderList.length - 1) {
        currentIndex++; // Sang câu tiếp theo
      } else {
        _finish(); // Hết từ rồi thì kết thúc
      }
    });
  }

  void _finish() {
    // Tính % chính xác đúng như công thức trong hình mày gửi
    double ratio = (correct / reminderList.length) * 100;

    showDialog(
      context: context,
      barrierDismissible: false, // Bắt buộc phải bấm nút mới đóng được
      builder: (context) => AlertDialog(
        title: const Text("Kết thúc bài kiểm tra", textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min, // Cho cái bảng nó gọn lại
          children: [
            Text("Tổng số câu: ${reminderList.length}"),
            Text("✔️ Đúng: $correct", style: const TextStyle(color: Colors.green)),
            Text("❌ Sai: $wrong", style: const TextStyle(color: Colors.red)),
            const Divider(),
            Text("Tỷ lệ chính xác: ${ratio.toStringAsFixed(1)}%",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context); // Đóng bảng điểm
                Navigator.pop(context); // Quay về trang chính luôn
              },
              child: const Text("HOÀN THÀNH")
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Nếu danh sách trống thì báo lỗi tránh văng app
    if (reminderList.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("Kiểm tra")),
        body: const Center(child: Text("Chưa có từ nào để kiểm tra!")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Trắc nghiệm Đúng / Sai")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hiển thị số thứ tự câu hỏi
            Text("Câu hỏi: ${currentIndex + 1} / ${reminderList.length}"),
            const SizedBox(height: 30),

            // Lấy từ tiếng Anh ra hiển thị
            Text(reminderList[currentIndex]['word']!,
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            // Lấy nghĩa tiếng Việt ra hiển thị
            Text("${reminderList[currentIndex]['meaning']}?",
                style: const TextStyle(fontSize: 24, color: Colors.blueGrey)),

            const SizedBox(height: 60),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120, height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () => checkAnswer(true),
                    child: const Text("✔️ Đúng", style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 30),
                SizedBox(
                  width: 120, height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () => checkAnswer(false),
                    child: const Text("❌ Sai", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}