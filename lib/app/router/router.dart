import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../di/di.dart';
import '../../domain/models/models.dart';
import '../features/features.dart';

final _rootNavigationKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final router = GoRouter(
  observers: [TalkerRouteObserver(talker)],
  debugLogDiagnostics: true,
  initialLocation: '/home',
  navigatorKey: _rootNavigationKey,
  routes: [
    // 1️⃣ ГЛАВНЫЙ ЭКРАН (Лаба 4)
    GoRoute(
      path: '/home',
      pageBuilder: (_, state) => MaterialPage(
        key: state.pageKey,
        child: const HomeScreen(),
      ),
    ),
    
    // Лаба 5
    GoRoute(
      path: '/content/:id',
      pageBuilder: (_, state) {
        final id = int.parse(state.pathParameters['id']!);
        final content = state.extra as Content?;
        
        return MaterialPage(
          key: state.pageKey,
          child: ContentScreen(
            contentId: id,
            initialContent: content,
          ),
        );
      },
    ),
  ],
);