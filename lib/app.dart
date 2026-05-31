import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarah_app/core/theme/app_theme.dart';
import 'package:sarah_app/presentation/bloc/mode_bloc.dart';
import 'package:sarah_app/routes.dart';

class SarahApp extends StatefulWidget {
  const SarahApp({super.key});

  @override
  State<SarahApp> createState() => _SarahAppState();
}

class _SarahAppState extends State<SarahApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ModeCubit, ModeState>(
      listenWhen: (previous, current) => previous.mode != current.mode,
      listener: (context, state) {
        final route = state.mode == AppMode.child
            ? AppRoutes.childHome
            : AppRoutes.parentHome;
        _navigatorKey.currentState?.pushNamedAndRemoveUntil(
          route,
          (_) => false,
        );
      },
      child: BlocBuilder<ModeCubit, ModeState>(
        builder: (context, state) {
          final isChild = state.mode == AppMode.child;

          return MaterialApp(
            navigatorKey: _navigatorKey,
            title: 'Sarah App',
            debugShowCheckedModeBanner: false,
            theme: isChild ? AppTheme.childTheme : AppTheme.parentTheme,
            initialRoute: isChild ? AppRoutes.childHome : AppRoutes.parentHome,
            onGenerateRoute: AppRoutes.generateRoute,
          );
        },
      ),
    );
  }
}
