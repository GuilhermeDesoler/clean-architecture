import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_project/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockConnectivity = MockConnectivity();
    networkInfoImpl = NetworkInfoImpl(connectivity: mockConnectivity);
  });

  group('IsConnected', () {
    const connectivityResult = ConnectivityResult.ethernet;

    test('Should forward the call to Connectivity.checkConnectivity', () async {
      // arrange
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => connectivityResult);
      // act
      final result = await networkInfoImpl.isConnected;
      // assert
      verify(mockConnectivity.checkConnectivity);
      expect(result, connectivityResult);
    });
  });
}
