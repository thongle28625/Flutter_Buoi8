import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  // ========================== INIT ==========================
  Future<void> init() async {
    tz.initializeTimeZones();
    // Thiết lập múi giờ Việt Nam
    tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    // Sử dụng đúng cấu trúc có tham số 'settings:'
    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (details) {},
    );

    await _requestPermission();
  }

  // ========================== XIN QUYỀN ==========================
  Future<void> _requestPermission() async {
    var status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    }
  }

  // Hàm phụ tạo cấu hình Android
  static AndroidNotificationDetails _createAndroidDetails() {
    return const AndroidNotificationDetails(
      'todo_channel',
      'Nhắc việc Todo',
      channelDescription: 'Thông báo hoàn thành nhiệm vụ',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
  }

  // ========================== GỬI THÔNG BÁO ==========================

  /// Gửi thông báo khi hoàn thành nhiệm vụ (Hiển thị số lượng)
  Future<void> showTaskNotification(int count) async {
    final details = _createAndroidDetails();

    // Sử dụng đúng tham số có tên để tránh lỗi "Too many positional arguments"
    await _plugin.show(
      id: 0,
      title: 'Chúc mừng!',
      body: 'Bạn đã hoàn thành $count nhiệm vụ.',
      notificationDetails: NotificationDetails(android: details),
    );
  }

  /// (Tùy chọn) Đặt lịch nhắc nhở theo giờ (Nếu bạn muốn dùng cho icon chuông)
  Future<void> scheduleTaskReminder({
    required int id,
    required String title,
    required DateTime scheduledTime,
  }) async {
    final details = _createAndroidDetails();

    await _plugin.zonedSchedule(
      id: id,
      title: 'Nhắc nhở nhiệm vụ',
      body: 'Đã đến giờ: $title',
      scheduledDate: tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails: NotificationDetails(android: details),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}