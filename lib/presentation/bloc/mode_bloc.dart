import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AppMode { child, parent }

class ModeState extends Equatable {
  final AppMode mode;
  const ModeState(this.mode);

  @override
  List<Object> get props => [mode];
}

class ModeCubit extends Cubit<ModeState> {
  ModeCubit() : super(const ModeState(AppMode.child));

  void switchToChild() => emit(const ModeState(AppMode.child));
  void switchToParent() => emit(const ModeState(AppMode.parent));
  void toggle() {
    final next =
        state.mode == AppMode.child ? AppMode.parent : AppMode.child;
    emit(ModeState(next));
  }
}
