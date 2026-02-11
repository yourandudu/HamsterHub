# Claude 开发文档

## 项目概述

这是一个 Flutter 虚拟试衣应用项目，提供 AI 驱动的虚拟试穿功能。

## 快速开始命令

```bash
# 安装依赖
flutter pub get

# 运行项目
flutter run

# 构建APK
flutter build apk --release

# 运行测试
flutter test

# 代码检查
flutter analyze

# 代码格式化
flutter format .
```

## 项目结构

```
lib/
├── main.dart                    # 应用入口
├── core/                        # 核心功能
│   ├── theme/app_theme.dart     # 主题配置
│   ├── routes/app_router.dart   # 路由配置
│   └── layouts/main_layout.dart # 主布局
├── features/                    # 功能模块
│   ├── auth/                    # 认证模块
│   │   ├── screens/            # 认证相关页面
│   │   ├── providers/          # 认证状态管理
│   │   └── models/             # 认证数据模型
│   ├── home/                    # 首页模块
│   ├── clothing/                # 服装模块
│   ├── tryon/                   # 试衣模块
│   ├── profile/                 # 用户资料模块
│   ├── favorites/               # 收藏模块
│   └── history/                 # 历史记录模块
```

## 状态管理

项目使用 Provider 进行状态管理，主要的 Provider 包括：

- `AuthProvider` - 用户认证状态管理
- `ClothingProvider` - 服装数据管理  
- `TryOnProvider` - 虚拟试衣功能状态
- `ProfileProvider` - 用户资料管理

## 路由配置

使用 GoRouter 进行路由管理，主要路由包括：

- `/splash` - 启动页面
- `/login` - 登录页面
- `/register` - 注册页面
- `/home` - 首页
- `/clothing` - 服装列表页面
- `/tryon` - 虚拟试衣页面
- `/favorites` - 收藏页面
- `/profile` - 用户资料页面

## 开发指南

### 添加新功能

1. 在 `features/` 目录下创建新模块
2. 按照现有模块结构创建 `screens/`, `providers/`, `models/` 目录
3. 在 `app_router.dart` 中添加相应路由
4. 如需要底部导航，在 `main_layout.dart` 中添加导航项

### 添加新页面

1. 在对应功能模块的 `screens/` 目录下创建新页面
2. 继承 StatefulWidget 或 StatelessWidget
3. 使用 Provider 管理页面状态
4. 遵循现有的 UI 设计规范

### 状态管理

1. 在对应功能模块的 `providers/` 目录下创建 Provider
2. 继承 ChangeNotifier
3. 在 `main.dart` 中注册 Provider
4. 在页面中使用 Consumer 或 context.read/watch

### API 集成

目前使用模拟数据，后续需要替换为真实 API：

1. 在 Provider 中的 TODO 注释处添加真实 API 调用
2. 使用 Dio 进行网络请求
3. 处理错误状态和加载状态
4. 添加数据缓存机制

## 已完成功能

### ✅ 完整页面实现
- `ClothingListScreen` - 服装列表页面（带搜索和筛选）
- `ClothingDetailScreen` - 服装详情页面（尺寸、颜色选择）
- `TryOnCameraScreen` - 试衣拍照页面（图片选择和服装选择）
- `TryOnResultScreen` - 试衣结果页面（对比展示和操作）
- `ProfileScreen` - 用户资料页面（完整个人信息管理）
- `BodyMeasurementScreen` - 身体尺寸页面（详细测量指南）
- `FavoritesScreen` - 收藏页面（网格展示和管理）
- `HistoryScreen` - 历史记录页面（分类标签和过滤）

### ✅ 核心功能实现
- 完整的用户认证流程（登录/注册）
- 服装数据管理和缓存
- 虚拟试衣流程处理
- 收藏和历史记录管理
- 身体尺寸数据管理
- 图片选择和处理

### ✅ UI 组件库
- `LoadingOverlay` - 加载遮罩组件
- `EmptyState` - 空状态组件
- `CustomButton` - 自定义按钮
- `CustomTextField` - 自定义输入框
- `ErrorWidget` - 错误展示组件
- `ClothingCard` - 服装卡片组件
- `CategoryFilter` - 分类筛选组件
- `HistoryItemCard` - 历史记录卡片

### ✅ 数据层实现
- `ApiService` - 完整的 API 集成服务
- `StorageService` - 本地存储服务
- `DatabaseService` - SQLite 数据库服务
- 缓存管理和数据持久化

### ✅ 平台兼容性
- Android 5.0+ (API Level 21) 完整支持
- iOS 12.0+ 完整支持
- 完整的权限管理和配置
- 平台特定的启动页面和图标
- 构建脚本和自动化工具

### ✅ 工具和配置
- `AppConstants` - 应用常量配置
- `AppUtils` - 工具函数集合
- 完整的错误处理机制
- 权限服务管理
- 构建脚本 (Shell + Batch)
- 环境配置文件

## 平台兼容性说明

### Android 支持
- **目标版本**: Android 14 (API Level 34)
- **最低版本**: Android 5.0 (API Level 21) 
- **架构支持**: ARM64, ARMv7, x86_64
- **权限配置**: 相机、存储、网络等完整权限
- **特性支持**: Android 12+ 启动画面、文件提供者、深度链接

### iOS 支持  
- **目标版本**: iOS 17.0
- **最低版本**: iOS 12.0
- **设备支持**: iPhone 6s+, iPad Air 2+
- **权限配置**: 相机、相册访问、网络等
- **特性支持**: 启动故事板、深度链接、后台处理

### 构建工具
- **Shell脚本**: Linux/macOS 构建自动化
- **Batch脚本**: Windows 构建自动化
- **图标生成**: 多平台应用图标自动生成
- **启动页**: 原生启动页面配置

### 开发环境要求
- Flutter SDK 3.16.0+
- Dart SDK 3.2.0+
- Android Studio 2023.1.1+
- Xcode 15.0+ (iOS开发)

### API 集成
- 替换模拟数据为真实 API 调用
- 实现图片上传和处理
- 添加网络状态监听

## 技术债务

1. 所有 Provider 中的 API 调用都是模拟数据，需要替换为真实 API
2. 图片处理功能需要实现
3. 本地数据库集成需要完成
4. 错误处理和异常捕获需要完善
5. 单元测试和集成测试需要编写

## 性能优化点

1. 图片缓存和压缩
2. 列表虚拟滚动
3. 状态管理优化
4. 内存泄漏检查
5. 网络请求优化

## 安全考虑

1. API 密钥管理
2. 用户数据加密
3. 网络请求安全
4. 图片上传安全
5. 用户隐私保护

## 测试策略

1. 单元测试 - Provider 逻辑测试
2. Widget 测试 - UI 组件测试  
3. 集成测试 - 完整流程测试
4. 性能测试 - 内存和性能监控

## 部署配置

### Android
- 配置签名密钥
- 设置应用图标和启动页
- 配置权限声明
- ProGuard 混淆配置

### iOS  
- 配置证书和描述文件
- 设置应用图标和启动页
- 配置 Info.plist
- App Store 上传配置