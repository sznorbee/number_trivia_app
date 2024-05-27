import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia_app/core/platform/network_info.dart';

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  late MockInternetConnectionChecker mockInternetConnectionChecker;
  late NetworkInfoImpl networkInfo;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfo = NetworkInfoImpl(mockInternetConnectionChecker);
  });

  group('Is Connected ?', () {
    test('Forward the call to InternetConnectionChecker.hasConnection',
        () async {
      // arrange
      when(() => mockInternetConnectionChecker.hasConnection)
          .thenAnswer((_) async => Future.value(true));
      // act
      networkInfo.isConnected;
      // assert
      verify(() => mockInternetConnectionChecker.hasConnection);
    });
  });
}
