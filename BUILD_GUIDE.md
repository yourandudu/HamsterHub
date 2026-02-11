# 构建和部署指南

## 🚀 快速开始

### 1. 环境准备
```bash
# 确保Flutter环境
flutter doctor

# 获取依赖
flutter pub get

# 生成图标和启动页
flutter pub run flutter_launcher_icons:main
flutter pub run flutter_native_splash:create
```

### 2. 开发调试
```bash
# 运行调试版本
flutter run

# 运行特定平台
flutter run -d android
flutter run -d ios
```

## 📱 Android构建

### Debug版本
```bash
# 使用脚本 (推荐)
./scripts/build.sh android-apk

# 或者直接命令
flutter build apk --debug
```

### Release版本
```bash
# 构建APK
./scripts/build.sh android-apk

# 构建App Bundle (推荐上架)
./scripts/build.sh android-bundle

# Windows用户
scripts\build.bat android-apk
```

### 签名配置
1. 创建 `android/key.properties`:
```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=your_key_alias
storeFile=path/to/your/keystore.jks
```

2. 生成签名密钥:
```bash
keytool -genkey -v -keystore android/app/upload-keystore.jks \
-keyalg RSA -keysize 2048 -validity 10000 \
-alias upload
```

## 🍎 iOS构建 (需要macOS)

### Debug版本
```bash
flutter build ios --debug --no-codesign
```

### Release版本
```bash
# 使用脚本
./scripts/build.sh ios-ipa

# 或者直接命令
flutter build ipa --release
```

### 签名配置
1. 在Xcode中配置开发者账户
2. 设置Bundle ID: `com.example.tryon`
3. 配置Code Signing
4. 更新`ios/Podfile`中的TEAM_ID

## 🔧 构建脚本使用

### Linux/macOS
```bash
# 完整构建
./scripts/build.sh all

# 只构建Android
./scripts/build.sh all-android

# 只构建iOS
./scripts/build.sh all-ios

# 查看所有选项
./scripts/build.sh help
```

### Windows
```batch
# 构建Android
scripts\build.bat all-android

# 查看帮助
scripts\build.bat help
```

## 📦 发布准备

### Google Play Store
1. 构建App Bundle:
```bash
flutter build appbundle --release
```

2. 上传到Play Console
3. 配置应用信息和截图
4. 提交审核

### App Store
1. 构建IPA:
```bash
flutter build ipa --release
```

2. 使用Xcode或Transporter上传
3. 在App Store Connect中配置
4. 提交审核

## 🛠️ 开发工具

### 代码质量
```bash
# 代码分析
flutter analyze

# 代码格式化
flutter format .

# 运行测试
flutter test
```

### 性能分析
```bash
# 性能分析
flutter run --profile

# 构建大小分析
flutter build apk --analyze-size
```

## 🐛 常见问题

### Q: 构建失败怎么办？
```bash
# 清理项目
flutter clean
flutter pub get

# 重新构建
flutter build apk
```

### Q: iOS构建签名问题？
- 确保在Xcode中正确配置开发者账户
- 检查Bundle ID是否正确
- 更新证书和描述文件

### Q: Android权限问题？
- 检查`AndroidManifest.xml`权限配置
- 确保targetSdkVersion设置正确

## 📊 构建产物

### Android
- APK位置: `build/app/outputs/flutter-apk/`
- App Bundle位置: `build/app/outputs/bundle/release/`

### iOS
- IPA位置: `build/ios/ipa/`
- Archive位置: `build/ios/archive/`

## 🔒 安全注意事项

1. **密钥管理**
   - 不要提交签名密钥到版本控制
   - 使用环境变量存储敏感信息

2. **代码保护**
   - Release版本启用代码混淆
   - 移除调试信息

3. **API安全**
   - 使用HTTPS
   - 实施API密钥轮换