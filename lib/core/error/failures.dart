import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{
  const Failure([List<dynamic> properties = const <dynamic>[]]): super();
}

class ServerFailure extends Failure {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class CacheFailure extends Failure {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}