import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class MeloApp extends ConsumerStatefulWidget {
  const MeloApp({super.key});

  @override
  ConsumerState<MeloApp> createState() => _MeloAppState();
}

class _MeloAppState extends ConsumerState<MeloApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initNotificationHandling();
    });
  }

  void _initNotificationHandling() {
    final notificationService = ref.read(notificationServiceProvider);
    final router = ref.read(appRouterProvider);
    notificationService.initialize(
      onNotificationTapped: (payload) {
        if (payload != null && payload.isNotEmpty) {
          router.go(payload);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final config = ref.watch(configProvider);

    return MaterialApp.router(
      title: config.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
