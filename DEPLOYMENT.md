# Deployment Guide - 部署指南

## 🚀 生产环境部署

### 前置要求
- Flutter SDK 3.16.0+
- 有效的开发者账户 (Google Play / App Store)
- 代码签名证书配置完成

## 📱 Android 部署

### 1. 准备发布构建

```bash
# 1. 清理项目
flutter clean && flutter pub get

# 2. 生成图标和启动页
flutter pub run flutter_launcher_icons:main
flutter pub run flutter_native_splash:create

# 3. 构建 App Bundle (推荐)
flutter build appbundle --release

# 4. 构建 APK (备选)
flutter build apk --release --split-per-abi
```

### 2. Google Play Console 配置

1. **创建应用**
   - 应用名称: Virtual Try-On
   - 默认语言: 中文 (中国)
   - 应用类型: 应用

2. **上传 App Bundle**
   - 位置: `build/app/outputs/bundle/release/app-release.aab`
   - 版本代码: 自动递增
   - 版本名称: 1.0.0

3. **应用信息配置**
   ```
   简短描述: AI驱动的虚拟试衣应用
   完整描述: 使用人工智能技术，让您在购买前虚拟试穿服装，提供逼真的试衣体验。
   
   分类: 生活时尚
   内容分级: 3岁以上
   目标受众: 18-65岁
   ```

4. **商店详情**
   - 应用图标: 512x512 PNG
   - 功能图片: 1024x500 PNG
   - 手机截图: 至少2张，最多8张
   - 平板截图: 推荐提供

### 3. 发布流程

```bash
# 内部测试 -> 封闭式测试 -> 开放式测试 -> 生产发布
```

## 🍎 iOS 部署

### 1. 准备发布构建

```bash
# 1. 清理项目
flutter clean && flutter pub get

# 2. 构建 IPA
flutter build ipa --release

# 3. 验证构建
xcrun altool --validate-app -f build/ios/ipa/*.ipa -t ios -u your-apple-id -p your-app-password
```

### 2. App Store Connect 配置

1. **创建 App ID**
   - Bundle ID: com.example.tryon
   - 启用功能: Camera, Photo Library Access

2. **证书和描述文件**
   ```bash
   # 创建分发证书
   # 创建 App Store 描述文件
   # 在 Xcode 中配置
   ```

3. **应用信息**
   ```
   应用名称: Virtual Try-On
   副标题: AI虚拟试衣
   分类: 生活方式
   内容分级: 4+
   ```

4. **版本信息**
   ```
   版本号: 1.0.0
   构建版本: 1
   新功能: 初始版本发布
   ```

### 3. 提交审核

```bash
# 使用 Transporter 或 Xcode
# 上传到 App Store Connect
# 提交审核
```

## 🔧 CI/CD 自动化部署

### GitHub Actions 配置

已配置在 `.github/workflows/ci.yml`:

1. **自动测试**: 推送到 main/develop 分支触发
2. **构建产物**: 生成 APK, AAB, IPA
3. **集成测试**: 在模拟器中运行
4. **自动发布**: 创建 GitHub Release

### 手动触发部署

```bash
# 触发 GitHub Actions
git tag v1.0.0
git push origin v1.0.0
```

## 🛡️ 安全配置

### 1. API 密钥管理

```bash
# 设置 GitHub Secrets
ANDROID_KEYSTORE_PASSWORD
ANDROID_KEY_PASSWORD  
IOS_CERTIFICATE_PASSWORD
APPLE_API_KEY
```

### 2. 代码签名

#### Android
```properties
# android/key.properties
storePassword=***
keyPassword=***
keyAlias=***
storeFile=../upload-keystore.jks
```

#### iOS
```bash
# 在 Xcode 中配置
# 团队: Your Development Team
# 签名证书: Distribution Certificate
```

## 📊 发布后监控

### 1. 崩溃监控
- Firebase Crashlytics
- Sentry

### 2. 性能监控
- Firebase Performance
- Google Analytics

### 3. 用户反馈
- Google Play Console 评论
- App Store Connect 评论
- 应用内反馈

## 🚀 发布清单

### 发布前检查
- [ ] 所有测试通过
- [ ] 代码审查完成
- [ ] 版本号更新
- [ ] 更新日志准备
- [ ] 应用图标和截图更新
- [ ] 隐私政策更新
- [ ] 用户协议确认

### Android 发布清单
- [ ] App Bundle 构建成功
- [ ] 代码签名正确
- [ ] 权限声明完整
- [ ] Google Play 政策合规
- [ ] 测试在多设备完成

### iOS 发布清单
- [ ] IPA 构建成功
- [ ] App Store 证书有效
- [ ] 隐私权限描述完整
- [ ] App Store 审核指南合规
- [ ] TestFlight 测试完成

## 🔄 发布策略

### 1. 分阶段发布
```
内测 (1%) -> 小范围测试 (5%) -> 全量发布 (100%)
```

### 2. A/B 测试
- 新功能特性测试
- UI/UX 优化测试
- 性能优化验证

### 3. 回滚计划
- 监控关键指标
- 准备紧急修复版本
- 快速回滚机制

## 📈 发布后跟进

1. **第一周**: 密切监控崩溃率、留存率
2. **第一月**: 收集用户反馈，规划优化
3. **长期**: 持续迭代，版本更新

## 常见问题

### Q: 构建失败怎么办？
- 检查 Flutter 版本
- 清理缓存重新构建
- 查看构建日志排错

### Q: 审核被拒怎么办？
- 仔细阅读拒绝原因
- 修复问题重新提交
- 必要时申诉说明

### Q: 如何处理紧急Bug？
- 立即修复关键问题
- 打包热修复版本
- 快速发布更新