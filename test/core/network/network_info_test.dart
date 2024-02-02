import 'package:clean_architecture_test/core/network/network_info.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<DataConnectionChecker>()])
import 'network_info_test.mocks.dart';

void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockDataConnectionChecker connectionChecker;

  setUp(() {
    connectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(connectionChecker);
  });

  group('isConnected', () {
    test('should forward the call to DataConnectionChecker.hasConnection',
        () async {
      final tHasConnectionFuture = Future.value(true);
      when(connectionChecker.hasConnection)
          .thenAnswer((_) => tHasConnectionFuture);
      final result = networkInfoImpl.isConnected;
      expect(result, tHasConnectionFuture);
      verify(connectionChecker.hasConnection);
    });
  });
}
