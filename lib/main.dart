import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarah_app/app.dart';
import 'package:sarah_app/presentation/bloc/mode_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(BlocProvider(create: (_) => ModeCubit(), child: const SarahApp()));
}
