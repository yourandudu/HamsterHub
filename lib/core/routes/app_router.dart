import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/screens/splash_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/clothing/screens/clothing_list_screen.dart';
import '../../features/clothing/screens/clothing_detail_screen.dart';
import '../../features/tryon/screens/tryon_camera_screen.dart';
import '../../features/tryon/screens/tryon_result_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/body_measurement_screen.dart';
import '../../features/favorites/screens/favorites_screen.dart';
import '../../features/history/screens/history_screen.dart';
import '../layouts/main_layout.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainLayout(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/clothing',
            builder: (context, state) => const ClothingListScreen(),
            routes: [
              GoRoute(
                path: 'detail/:id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return ClothingDetailScreen(clothingId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/tryon',
            builder: (context, state) => const TryOnCameraScreen(),
            routes: [
              GoRoute(
                path: 'result',
                builder: (context, state) => const TryOnResultScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/favorites',
            builder: (context, state) => const FavoritesScreen(),
          ),
          GoRoute(
            path: '/history',
            builder: (context, state) => const HistoryScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'measurements',
                builder: (context, state) => const BodyMeasurementScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}