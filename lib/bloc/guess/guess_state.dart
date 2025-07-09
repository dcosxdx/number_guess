part of 'guess_bloc.dart';

// States
abstract class GuessState {}

class GuessInitial extends GuessState {}

class Guessing extends GuessState {}

class GuessResult extends GuessState {
  final bool? isBig; // null: correct, true: too big, false: too small
  final bool guessing;
  GuessResult({required this.isBig, required this.guessing});
}
