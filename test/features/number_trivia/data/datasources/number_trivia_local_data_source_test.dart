import 'dart:convert';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia_app/core/error/exceptions.dart';
import 'package:number_trivia_app/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/fixtures/fixtures_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late NumberTriviaLocalDataSourceImpl dataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

    test(
      'Return NumberTrivia from SharedPreferences when there is one in the cache',
      () async {
        // arrange
        when(() => mockSharedPreferences.getString(any()))
            .thenReturn(fixture('trivia_cached.json'));
        // act
        final result = await dataSource.getLastNumberTrivia();
        // assert
        verify(() => mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'Return CacheException when there is no cached value',
      () async {
        // arrange
        when(() => mockSharedPreferences.getString(any())).thenReturn(null);
        // act
        final call = dataSource.getLastNumberTrivia;
        // assert
        expect(() => call(), throwsA(isA<CacheException>()));
      },
    );
  });

  group('cacheNumberTrivia', () {
    const tNumberTriviaModel =
        NumberTriviaModel(number: 1, text: 'Test Trivia');
    test(
      'Call SharedPreferences to cache the data',
      () async {
        // arrange
        when(() => mockSharedPreferences.setString(any(), any()))
            .thenAnswer((_) async => true);
        // act
        dataSource.cacheNumberTrivia(tNumberTriviaModel);
        // assert
        final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
        verify(() => mockSharedPreferences.setString(
            CACHED_NUMBER_TRIVIA, expectedJsonString));
      },
    );
  });
}
