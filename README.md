# Virtual Try-On Flutter App

## 项目概述

这是一个基于 Flutter 的虚拟试衣应用，使用 AI 技术为用户提供虚拟试穿体验。用户可以上传自己的照片，选择喜欢的服装进行虚拟试穿，并查看效果。

## 功能特性

### 核心功能
- 🔐 **用户认证** - 注册、登录、个人资料管理
- 👔 **服装展示** - 浏览、搜索、分类筛选服装
- 📸 **虚拟试衣** - AI 驱动的虚拟试穿功能
- 💝 **收藏功能** - 收藏喜欢的服装
- 📱 **试衣历史** - 查看历史试衣记录
- 📏 **身材管理** - 身体尺寸记录和管理

### 技术特性
- 📱 响应式设计，支持多种屏幕尺寸
- 🎨 现代化 Material Design 3 UI
- 🔄 状态管理使用 Provider
- 🛣️ 使用 GoRouter 进行路由管理
- 🖼️ 图片缓存和处理
- 💾 本地数据持久化

## 项目结构

```
lib/
├── main.dart                    # 应用入口
├── core/                        # 核心功能
│   ├── theme/                   # 主题配置
│   ├── routes/                  # 路由配置
│   └── layouts/                 # 布局组件
├── features/                    # 功能模块
│   ├── auth/                    # 认证模块
│   │   ├── screens/
│   │   ├── providers/
│   │   └── models/
│   ├── home/                    # 首页模块
│   ├── clothing/                # 服装模块
│   ├── tryon/                   # 试衣模块
│   ├── profile/                 # 用户资料模块
│   ├── favorites/               # 收藏模块
│   └── history/                 # 历史记录模块
└── shared/                      # 共享组件和工具
    ├── widgets/
    ├── utils/
    └── constants/
```

## 平台支持

### ✅ Android
- **目标版本**: Android 14 (API Level 34)
- **最低版本**: Android 5.0 (API Level 21)
- **架构支持**: ARM64, ARMv7, x86_64
- **特性**: 自适应图标、启动画面、文件提供者、权限管理

### ✅ iOS
- **目标版本**: iOS 17.0
- **最低版本**: iOS 12.0  
- **设备支持**: iPhone 6s及以上, iPad Air 2及以上
- **特性**: 启动故事板、深度链接、后台处理、隐私权限

### 框架和库
- **Flutter** - 跨平台移动应用开发框架
- **Provider** - 状态管理
- **GoRouter** - 路由管理
- **Dio** - HTTP 网络请求
- **SharedPreferences** - 本地数据存储
- **SQLite** - 本地数据库
- **Image Picker** - 图片选择
- **Cached Network Image** - 图片缓存

### 开发工具
- **Dart** - 编程语言
- **Material Design 3** - UI 设计系统
- **Permission Handler** - 权限管理

## 快速开始

### 环境要求
- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio / VS Code
- iOS 开发需要 Xcode

### 安装步骤

1. **克隆项目**
   ```bash
   git clone <repository-url>
   cd tryon
   ```

2. **安装依赖**
   ```bash
   flutter pub get
   ```

3. **运行应用**
   ```bash
   flutter run
   ```

### 快速构建

#### 使用构建脚本 (推荐)
```bash
# Linux/macOS
./scripts/build.sh all          # 构建所有平台
./scripts/build.sh android-apk  # 仅构建Android APK
./scripts/build.sh ios-ipa      # 仅构建iOS IPA

# Windows
scripts\build.bat all-android   # 构建Android
```

#### 手动构建
```bash
# Android
flutter build apk --release --split-per-abi
flutter build appbundle --release

# iOS (需要macOS)
flutter build ios --release
flutter build ipa --release
```

## 架构设计

### 状态管理
使用 Provider 模式进行状态管理，主要 Provider 包括：
- `AuthProvider` - 用户认证状态
- `ClothingProvider` - 服装数据管理
- `TryOnProvider` - 试衣功能状态
- `ProfileProvider` - 用户资料管理

### 路由结构
```
/splash           # 启动屏幕
/login            # 登录页面
/register         # 注册页面
/home             # 首页
/clothing         # 服装列表
  /detail/:id     # 服装详情
/tryon            # 虚拟试衣
  /result         # 试衣结果
/favorites        # 收藏列表
/history          # 历史记录
/profile          # 用户资料
  /measurements   # 身体尺寸
```

### 数据模型
- `ClothingModel` - 服装数据模型
- `TryOnModel` - 试衣记录模型
- `UserModel` - 用户信息模型

## API 集成

### 服装数据 API
```dart
// 获取服装列表
GET /api/clothing
GET /api/clothing/categories
GET /api/clothing/{id}

// 搜索服装
GET /api/clothing/search?q={query}
```

### 虚拟试衣 API
```dart
// 上传图片并处理试衣
POST /api/tryon
{
  "user_image": "base64_image",
  "clothing_id": "clothing_id"
}
```

### 用户管理 API
```dart
// 用户认证
POST /api/auth/login
POST /api/auth/register

// 用户资料
GET /api/user/profile
PUT /api/user/profile
```

## UI 组件

### 自定义组件
- `ClothingCard` - 服装卡片组件
- `TryOnResult` - 试衣结果展示组件
- `CategoryChip` - 分类标签组件
- `LoadingOverlay` - 加载遮罩组件

### 通用组件
- `CustomButton` - 自定义按钮
- `CustomTextField` - 自定义输入框
- `EmptyState` - 空状态组件
- `ErrorWidget` - 错误提示组件

## 性能优化

### 图片优化
- 使用 `cached_network_image` 进行图片缓存
- 图片懒加载和压缩
- 支持占位符和错误状态

### 列表优化
- 使用 `ListView.builder` 进行虚拟滚动
- 分页加载数据
- 状态保持和恢复

### 内存管理
- 及时释放不用的资源
- 合理使用 Provider 避免内存泄漏
- 图片内存优化

## 测试

### 单元测试
```bash
flutter test test/unit/
```

### Widget 测试
```bash
flutter test test/widget/
```

### 集成测试
```bash
flutter test integration_test/
```

## 部署

### Android 发布
1. 配置签名
2. 构建 release APK: `flutter build apk --release`
3. 上传到 Google Play Store

### iOS 发布
1. 配置 Xcode 项目
2. 构建 release IPA: `flutter build ipa --release`
3. 上传到 App Store Connect

## 贡献指南

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开 Pull Request

## 许可证

本项目使用 MIT 许可证。详情请查看 [LICENSE](LICENSE) 文件。

## 联系方式

- 项目维护者: [Your Name]
- 邮箱: [your.email@example.com]
- 项目链接: [GitHub Repository URL]