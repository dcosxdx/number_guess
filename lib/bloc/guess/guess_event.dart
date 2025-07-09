part of 'guess_bloc.dart';

// Events
abstract class GuessEvent {}

class GenerateRandom extends GuessEvent {}

class CheckGuess extends GuessEvent {
  final int guess;
  CheckGuess(this.guess);
}
