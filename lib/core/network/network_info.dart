// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl({
    required this.connectivity,
  });

  final Connectivity connectivity;

  @override
  Future<bool> get isConnected async {
    final connectivityResult = await connectivity.checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else if (connectivityResult == ConnectivityResult.ethernet) {
      return true;
    } else if (connectivityResult == ConnectivityResult.vpn) {
      return false;
    } else if (connectivityResult == ConnectivityResult.bluetooth) {
      return false;
    } else if (connectivityResult == ConnectivityResult.other) {
      return false;
    }

    return false;
  }
}
