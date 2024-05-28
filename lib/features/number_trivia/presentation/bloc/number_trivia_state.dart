part of 'number_trivia_bloc.dart';

sealed class NumberTriviaState extends Equatable {
  const NumberTriviaState();

  @override
  List<Object> get props => [];
}

final class Empty extends NumberTriviaState {}

final class Loading extends NumberTriviaState {}

final class Loaded extends NumberTriviaState {
  final NumberTrivia trivia;

  const Loaded(this.trivia);

  @override
  List<Object> get props => [trivia];
}

final class Error extends NumberTriviaState {
  final String message;

  const Error(this.message);

  @override
  List<Object> get props => [message];
}
