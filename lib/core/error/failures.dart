import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([this.properties = const []]);
  final List<dynamic> properties;

  @override
  List<dynamic> get props => properties;
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}
