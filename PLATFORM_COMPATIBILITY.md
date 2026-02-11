# Virtual Try-On - Platform Compatibility Guide

## 支持的平台

### ✅ Android
- **最低版本**: Android 5.0 (API Level 21)
- **推荐版本**: Android 8.0+ (API Level 26+)
- **目标版本**: Android 14 (API Level 34)
- **架构支持**: ARM64, ARMv7, x86_64

### ✅ iOS  
- **最低版本**: iOS 12.0
- **推荐版本**: iOS 15.0+
- **目标版本**: iOS 17.0
- **设备支持**: iPhone 6s及以上, iPad Air 2及以上

## 权限要求

### Android权限
```xml
<!-- 必需权限 -->
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />

<!-- Android 13+权限 -->
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />

<!-- 可选权限 -->
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
```

### iOS权限
```xml
<!-- 相机权限 -->
<key>NSCameraUsageDescription</key>
<string>用于拍摄试衣照片</string>

<!-- 相册权限 -->
<key>NSPhotoLibraryUsageDescription</key>
<string>用于选择试衣照片</string>

<!-- 保存照片权限 -->
<key>NSPhotoLibraryAddUsageDescription</key>
<string>用于保存试衣结果</string>
```

## 构建要求

### 开发环境
- **Flutter SDK**: 3.16.0+
- **Dart SDK**: 3.2.0+
- **Android Studio**: 2023.1.1+
- **Xcode**: 15.0+ (仅iOS开发)

### Android构建
```bash
# 构建APK
flutter build apk --release --split-per-abi

# 构建App Bundle
flutter build appbundle --release

# 构建调试版本
flutter build apk --debug
```

### iOS构建 (仅macOS)
```bash
# 构建iOS应用
flutter build ios --release

# 构建IPA
flutter build ipa --release

# 构建调试版本
flutter build ios --debug
```

## 设备要求

### Android设备
- **RAM**: 最低2GB，推荐4GB+
- **存储空间**: 最低100MB可用空间
- **相机**: 支持自动对焦的后置摄像头
- **网络**: 支持WiFi或移动数据网络

### iOS设备
- **RAM**: 最低2GB，推荐3GB+
- **存储空间**: 最低100MB可用空间  
- **相机**: 支持自动对焦的后置摄像头
- **网络**: 支持WiFi或蜂窝数据网络

## 性能优化

### Android优化
- 使用ProGuard代码混淆和压缩
- 启用APK分包以减小下载大小
- 支持Android 12+的启动画面API
- 优化内存使用和电池消耗

### iOS优化  
- 支持iOS暗黑模式
- 优化启动时间和内存占用
- 使用iOS 14+的Widget功能
- 支持iPad多任务处理

## 测试设备覆盖

### Android测试设备
- **入门级**: Samsung Galaxy A32, Xiaomi Redmi Note 10
- **中端**: Google Pixel 6a, OnePlus Nord 2  
- **高端**: Samsung Galaxy S23, Google Pixel 7 Pro
- **平板**: Samsung Galaxy Tab A8, Lenovo Tab P11

### iOS测试设备
- **iPhone**: iPhone SE (2nd gen), iPhone 12, iPhone 14 Pro
- **iPad**: iPad (9th gen), iPad Air (5th gen), iPad Pro 12.9"

## 国际化支持

### 支持语言
- 🇨🇳 简体中文 (默认)
- 🇺🇸 English
- 🇯🇵 日本語
- 🇰🇷 한국어

### 本地化功能
- 界面文本翻译
- 日期时间格式
- 数字货币格式
- 从右到左语言支持准备

## 发布渠道

### Android发布
- **Google Play Store** (主要渠道)
- **Samsung Galaxy Store** 
- **华为应用市场** (中国地区)
- **APK直接下载** (企业版本)

### iOS发布
- **App Store** (唯一官方渠道)
- **TestFlight** (测试版本)
- **Enterprise Distribution** (企业版本)

## 安全与隐私

### 数据保护
- 用户照片本地加密存储
- 网络传输使用HTTPS/TLS
- 遵循GDPR隐私法规
- 支持用户数据删除

### 应用安全
- 代码混淆和反逆向
- API密钥安全管理
- 生物识别认证支持
- 防截屏录屏保护

## 常见问题

### Q: 为什么需要相机权限？
A: 应用需要相机权限来拍摄用户照片进行虚拟试衣。

### Q: 应用是否支持离线使用？
A: 部分功能支持离线使用，但虚拟试衣需要网络连接。

### Q: 最低系统要求是什么？
A: Android 5.0+ 或 iOS 12.0+，推荐使用更新版本。

### Q: 应用大小是多少？
A: Android APK约25-30MB，iOS IPA约35-40MB。