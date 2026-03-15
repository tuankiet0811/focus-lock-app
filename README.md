# focus-lock-app

## Project Overview
- Ứng dụng Flutter giúp tập trung bằng cách chặn ứng dụng gây xao nhãng trong thời gian tập trung.
- Hoạt động hoàn toàn cục bộ, không có backend hay API từ xa.
- Cung cấp phiên tập trung, timer trực quan, thống kê, thông báo động viên, và danh sách ứng dụng bị chặn.

## Architecture
- Presentation: MaterialApp và màn hình chính [main.dart](lib/main.dart) với Provider làm state container.
- State management: ChangeNotifier trong [FocusService](lib/services/focus_service.dart) điều phối phiên tập trung, timer, thống kê.
- Services:
  - Lưu trữ cục bộ: [StorageService](lib/services/storage_service.dart) dùng SharedPreferences cho blocked apps và sessions.
  - Thông báo: [NotificationService](lib/services/notification_service.dart) cấu hình kênh và gửi thông báo.
  - Chặn ứng dụng: [AppBlockingService](lib/services/app_blocking_service.dart) giao tiếp native qua MethodChannel.
  - Danh sách ứng dụng: [AppUsageService](lib/services/app_usage_service.dart) cung cấp dữ liệu ứng dụng phổ biến.
- Models: [FocusSession](lib/models/focus_session.dart), [AppInfo](lib/models/app_info.dart).
- UI components: [FocusTimerWidget](lib/widgets/focus_timer_widget.dart), QuickStart, Stats.
- Config: [constants.dart](lib/utils/constants.dart) định nghĩa màu sắc, IDs kênh thông báo, danh sách mặc định.

## Features
- Quản lý phiên tập trung: bắt đầu, tạm dừng, tiếp tục, dừng.
- Timer trực quan và thông báo động viên theo mốc thời gian.
- Chặn ứng dụng phổ biến (Facebook, Instagram, TikTok, YouTube, Netflix, v.v.).
- Thống kê theo ngày/tuần, lịch sử phiên, chuỗi thành tích.
- Tùy chỉnh danh sách ứng dụng bị chặn.

## Requirements
- Flutter SDK ≥ 3.8.1, Dart SDK ≥ 3.8.1.
- Android Studio hoặc VS Code; Android SDK cho Android, Xcode cho iOS (macOS).
- Quyền hệ thống: Usage Stats, Overlay, Foreground Service, Notifications.

## Tech Stack
- Flutter, Dart, Material Design 3, Provider.
- SharedPreferences (lưu trữ cục bộ).
- flutter_local_notifications (thông báo).
- workmanager (nền tảng tác vụ nền, có thể mở rộng).
- permission_handler, intl, lottie, flutter_svg, package_info_plus.

## Installation Instructions
- Clone và cài đặt:
  - git clone <repository-url>
  - cd focuslock
  - flutter pub get
- Chạy development: flutter run
- Build:
  - Android APK: flutter build apk --release
  - Android App Bundle: flutter build appbundle --release
  - iOS: flutter build ios --release

## Main Endpoints
- Không có HTTP API hay backend.
- Native MethodChannel: focuslock/app_blocking cho chặn ứng dụng.
- Notification channels: focus_channel, app_blocked_channel.

## Security Considerations
- Dữ liệu chỉ lưu cục bộ (sessions, danh sách app bị chặn) bằng SharedPreferences; không thu thập PII, không gửi dữ liệu ra ngoài.
- Quyền nhạy cảm:
  - PACKAGE_USAGE_STATS: theo dõi app đang sử dụng để chặn.
  - SYSTEM_ALERT_WINDOW: hiển thị overlay cảnh báo khi mở app bị chặn.
  - FOREGROUND_SERVICE, POST_NOTIFICATIONS, VIBRATE, WAKE_LOCK: đảm bảo service và thông báo hoạt động ổn định.
- Minh bạch và đồng thuận: người dùng chủ động bật quyền; giải thích rõ mục đích sử dụng quyền.
- Bảo vệ kênh native: kiểm tra dữ liệu truyền qua MethodChannel, tránh thực thi lệnh tùy ý.
- Không có kết nối mạng mặc định; nếu mở rộng, cần bổ sung mã hóa giao tiếp và kiểm soát truy cập.
