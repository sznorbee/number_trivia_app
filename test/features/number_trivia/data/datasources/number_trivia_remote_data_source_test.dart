import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:number_trivia_app/core/error/exceptions.dart';
import 'package:number_trivia_app/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia_app/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../core/fixtures/fixtures_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
    registerFallbackValue(FakeUri());
  });

  void setUpMockHttpClientSuccess200() {
    when(() => mockHttpClient.get(
          any(),
          headers: any(named: 'headers'),
        )).thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(() => mockHttpClient.get(
          any(),
          headers: any(named: 'headers'),
        )).thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final Uri url = Uri.parse('http://numbersapi.com/$tNumber');
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
      json.decode(fixture('trivia.json')),
    );
    test(
      'Perform a GET request on a URL with number being the endpoint and with application/json header',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        dataSource.getConcreteNumberTrivia(tNumber);
        // assert
        verify(() => mockHttpClient.get(
              url,
              headers: {'Content-Type': 'application/json'},
            ));
      },
    );

    test(
      'Return NumberTrivia when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.getConcreteNumberTrivia(tNumber);
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'Throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getConcreteNumberTrivia;
        // assert
        expect(() => call(tNumber), throwsA(isA<ServerException>()));
      },
    );
  });

  group('getRandomNumberTrivia', () {
    final Uri url = Uri.parse('http://numbersapi.com/random');
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
      json.decode(fixture('trivia.json')),
    );
    test(
      'Perform a GET request on a URL without number being the endpoint and with application/json header',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        dataSource.getRandomNumberTrivia();
        // assert
        verify(() => mockHttpClient.get(
              url,
              headers: {'Content-Type': 'application/json'},
            ));
      },
    );

    test(
      'Return NumberTrivia when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.getRandomNumberTrivia();
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'Throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getRandomNumberTrivia;
        // assert
        expect(() => call(), throwsA(isA<ServerException>()));
      },
    );
  });
}
