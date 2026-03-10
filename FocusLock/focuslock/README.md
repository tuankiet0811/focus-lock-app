# FocusLock - Ứng dụng chống nghiện điện thoại

FocusLock là một ứng dụng Flutter được thiết kế để giúp bạn tập trung vào công việc quan trọng bằng cách chặn các ứng dụng mạng xã hội và giải trí trong thời gian tập trung.

## 🌟 Tính năng chính

### 🎯 Quản lý phiên tập trung
- **Bắt đầu nhanh**: Chọn thời gian tập trung từ 15 phút đến 2 giờ
- **Mục tiêu tùy chỉnh**: Đặt mục tiêu cụ thể cho mỗi phiên tập trung
- **Timer trực quan**: Hiển thị thời gian còn lại với giao diện đẹp mắt
- **Tạm dừng/Tiếp tục**: Linh hoạt trong việc quản lý phiên tập trung

### 🚫 Chặn ứng dụng
- **Danh sách ứng dụng bị chặn**: Facebook, Instagram, TikTok, Twitter, Threads, Snapchat, WhatsApp, Telegram, Discord, Reddit, Pinterest, LinkedIn, Spotify, Netflix, YouTube
- **Tùy chỉnh danh sách**: Thêm/xóa ứng dụng khỏi danh sách bị chặn
- **Thông báo cảnh báo**: Hiển thị thông báo khi cố gắng mở ứng dụng bị chặn

### 📊 Thống kê và theo dõi
- **Thống kê hàng ngày**: Theo dõi thời gian tập trung mỗi ngày
- **Thống kê hàng tuần**: Tổng quan tiến độ trong tuần
- **Lịch sử phiên**: Xem lại các phiên tập trung đã hoàn thành
- **Chuỗi thành tích**: Theo dõi số ngày liên tiếp tập trung

### 🔔 Thông báo thông minh
- **Thông báo bắt đầu**: Thông báo khi phiên tập trung bắt đầu
- **Thông báo kết thúc**: Chúc mừng khi hoàn thành phiên tập trung
- **Thông báo động viên**: Gửi tin nhắn động viên trong quá trình tập trung
- **Thông báo chặn app**: Cảnh báo khi cố gắng mở ứng dụng bị chặn

## 🚀 Cài đặt và chạy

### Yêu cầu hệ thống
- Flutter SDK 3.8.1 trở lên
- Dart SDK 3.8.1 trở lên
- Android Studio / VS Code
- Android SDK (cho Android)
- Xcode (cho iOS - macOS only)

### Cài đặt

1. **Clone repository**
```bash
git clone <repository-url>
cd focuslock
```

2. **Cài đặt dependencies**
```bash
flutter pub get
```

3. **Chạy ứng dụng**
```bash
flutter run
```

### Build cho production

**Android APK:**
```bash
flutter build apk --release
```

**Android App Bundle (cho Google Play):**
```bash
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

## 📱 Hướng dẫn sử dụng

### 1. Bắt đầu phiên tập trung
- Mở ứng dụng FocusLock
- Chọn thời gian tập trung (15, 25, 45, 60, 90, 120 phút)
- Nhập mục tiêu (tùy chọn)
- Nhấn "Bắt đầu tập trung"

### 2. Quản lý ứng dụng bị chặn
- Vào tab "Ứng dụng"
- Bật/tắt các ứng dụng muốn chặn
- Tìm kiếm ứng dụng cụ thể
- Lưu cài đặt

### 3. Theo dõi tiến độ
- Xem thống kê trên trang chủ
- Kiểm tra lịch sử phiên tập trung
- Theo dõi chuỗi thành tích

### 4. Cài đặt thông báo
- Vào Cài đặt
- Bật/tắt các loại thông báo
- Tùy chỉnh âm thanh và rung

## 🔧 Cấu hình cho Google Play

### 1. Cập nhật thông tin ứng dụng
- Sửa `pubspec.yaml`:
  ```yaml
  name: focuslock
  description: "FocusLock - Ứng dụng chống nghiện điện thoại, giúp bạn tập trung vào công việc quan trọng"
  version: 1.0.0+1
  ```

### 2. Cấu hình Android
- Cập nhật `android/app/src/main/AndroidManifest.xml` với permissions cần thiết
- Thêm icon ứng dụng vào `android/app/src/main/res/mipmap-*`
- Cập nhật `android/app/src/main/res/values/strings.xml`

### 3. Tạo keystore cho release
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

### 4. Cấu hình signing
Tạo file `android/key.properties`:
```properties
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=<path to keystore>
```

## 🛠️ Cấu trúc dự án

```
lib/
├── models/           # Data models
│   ├── focus_session.dart
│   └── app_info.dart
├── screens/          # UI screens
│   ├── home_screen.dart
│   └── apps_screen.dart
├── services/         # Business logic
│   ├── focus_service.dart
│   ├── storage_service.dart
│   ├── notification_service.dart
│   └── app_blocking_service.dart
├── widgets/          # Reusable widgets
│   ├── focus_timer_widget.dart
│   ├── quick_start_widget.dart
│   └── stats_widget.dart
├── utils/            # Utilities and constants
│   ├── constants.dart
│   └── helpers.dart
└── main.dart         # App entry point
```

## 📋 Permissions

Ứng dụng yêu cầu các quyền sau:

- **PACKAGE_USAGE_STATS**: Theo dõi việc sử dụng ứng dụng
- **SYSTEM_ALERT_WINDOW**: Hiển thị overlay khi chặn ứng dụng
- **FOREGROUND_SERVICE**: Chạy service trong nền
- **POST_NOTIFICATIONS**: Gửi thông báo
- **VIBRATE**: Rung khi có thông báo
- **WAKE_LOCK**: Giữ màn hình sáng

## 🎨 Giao diện

Ứng dụng sử dụng Material Design 3 với:
- **Màu chủ đạo**: Xanh dương (#2196F3)
- **Màu phụ**: Cam (#FF5722)
- **Màu thành công**: Xanh lá (#4CAF50)
- **Màu cảnh báo**: Vàng (#FF9800)
- **Màu lỗi**: Đỏ (#F44336)

## 🔮 Tính năng tương lai

- [ ] Chế độ tối (Dark mode)
- [ ] Đồng bộ dữ liệu đám mây
- [ ] Chia sẻ thành tích
- [ ] Thách thức hàng ngày
- [ ] Tích hợp với Google Fit
- [ ] Widget màn hình chính
- [ ] Hỗ trợ Apple Watch
- [ ] Tích hợp với calendar

## 🤝 Đóng góp

Chúng tôi hoan nghênh mọi đóng góp! Vui lòng:

1. Fork dự án
2. Tạo feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit thay đổi (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Mở Pull Request

## 📄 Giấy phép

Dự án này được phân phối dưới giấy phép MIT. Xem file `LICENSE` để biết thêm chi tiết.

## 📞 Liên hệ

- **Email**: support@focuslock.app
- **Website**: https://focuslock.app
- **GitHub**: https://github.com/focuslock

## 🙏 Cảm ơn

Cảm ơn bạn đã sử dụng FocusLock! Chúng tôi hy vọng ứng dụng này sẽ giúp bạn tập trung tốt hơn và đạt được mục tiêu của mình.

---

**FocusLock** - Tập trung để thành công! 🎯
