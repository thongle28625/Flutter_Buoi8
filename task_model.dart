class Task {
  String title;
  String reminderTime;
  bool isCompleted;

  Task({required this.title, required this.reminderTime, this.isCompleted = false});

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    title: json['title'],
    reminderTime: json['reminderTime'],
    isCompleted: json['isCompleted'],
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'reminderTime': reminderTime,
    'isCompleted': isCompleted,
  };
}