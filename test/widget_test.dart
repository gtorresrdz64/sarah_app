import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sarah_app/app.dart';
import 'package:sarah_app/presentation/bloc/mode_bloc.dart';

void main() {
  testWidgets('App renders child home screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      BlocProvider(
        create: (_) => ModeCubit(),
        child: const MaterialApp(home: SarahApp()),
      ),
    );
    expect(find.text('¡Hola Sarah!'), findsOneWidget);
  });
}
