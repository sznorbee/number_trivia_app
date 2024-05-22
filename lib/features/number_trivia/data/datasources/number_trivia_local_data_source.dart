import 'package:number_trivia_app/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  /// Caches the [NumberTriviaModel] to the local device.
  ///
  /// Throws [CacheException] if the data cannot be cached.
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}