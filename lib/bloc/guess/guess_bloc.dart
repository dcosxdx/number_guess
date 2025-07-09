import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'guess_event.dart';
part 'guess_state.dart';

class GuessBloc extends Bloc<GuessEvent, GuessState> {
  final Random _random = Random();
  int _value = 0;
  bool _guessing = false;

  GuessBloc() : super(GuessInitial()) {
    on<GenerateRandom>((event, emit) {
      _value = _random.nextInt(100);
      print(_value);
      _guessing = true;
      emit(Guessing());
    });

    on<CheckGuess>((event, emit) {
      if (!_guessing) return;
      if (event.guess == _value) {
        _guessing = false;
        emit(GuessResult(isBig: null, guessing: false));
      } else {
        emit(GuessResult(isBig: event.guess > _value, guessing: true));
      }
    });
  }
}
