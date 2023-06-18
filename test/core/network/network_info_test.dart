import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_project/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([
  Connectivity,
])
void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockConnectivity = MockConnectivity();
    networkInfoImpl = NetworkInfoImpl(connectivity: mockConnectivity);
  });

  group('IsConnected', () {
    final tConnectivityResult = Future.value(ConnectivityResult.ethernet);

    test('Should forward the call to Connectivity.checkConnectivity', () async {
      // arrange
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => tConnectivityResult);
      // act
      final result = await networkInfoImpl.isConnected;
      // assert
      verify(mockConnectivity.checkConnectivity());
      expect(result, true);
    });
  });

  group('isDisconnected', () {
    final tConnectivityResult = Future.value(ConnectivityResult.bluetooth);

    test('Should forward the call to Connectivity.checkConnectivity', () async {
      // arrange
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => tConnectivityResult);
      // act
      final result = await networkInfoImpl.isConnected;
      // assert
      verify(mockConnectivity.checkConnectivity());
      expect(result, false);
    });
  });
}
