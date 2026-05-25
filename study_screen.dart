import 'package:flutter/material.dart';

class StudyScreen extends StatefulWidget {
  const StudyScreen({super.key});
  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  int correct = 0;
  int wrong = 0;
  final inputController = TextEditingController();

  void check() {
    setState(() {
      // Giả sử từ đang học là "subject" - nghĩa là "môn học"
      if (inputController.text.trim() == "Mon hoc") {
        correct++;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Chính xác!"), backgroundColor: Colors.green));
      } else {
        wrong++;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sai rồi!"), backgroundColor: Colors.red));

        // LOGIC QUAN TRỌNG: Nếu số câu sai chia hết cho 3
        if (wrong % 3 == 0) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Cảnh báo"),
              content: Text("Bạn đã sai $wrong lần rồi đó!"),
              actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ôn tập từ mới")),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(padding: const EdgeInsets.all(10), color: Colors.green, child: Text("✔️ $correct từ")),
              Container(padding: const EdgeInsets.all(10), color: Colors.orange, child: Text("❌ $wrong từ")),
            ],
          ),
          const SizedBox(height: 50),
          const Text("subject", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(controller: inputController, decoration: const InputDecoration(hintText: "Nhập nghĩa tiếng Việt")),
          ),
          ElevatedButton(onPressed: check, child: const Text("Check")),
        ],
      ),
    );
  }
}