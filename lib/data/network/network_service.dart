import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../presentation/screens/cubit/base_view_model.dart';

enum NetworkStatus { Online, Offline }

class NetworkStatusService {
  StreamController<NetworkStatus> networkStatusController = StreamController<NetworkStatus>();

  NetworkStatusService() {
    if (kIsWeb) {
      networkStatusController.add(NetworkStatus.Online);
      BaseViewModel().setConnectionStatus(true);
      return;
    }
    InternetConnectionChecker().onStatusChange.listen((event) {
      debugPrint("Checking Connection and status is $event");
      BaseViewModel().setConnectionStatus(event == InternetConnectionStatus.connected);
      networkStatusController.add(_getNetworkStatus(event == InternetConnectionStatus.connected));
    });
  }

  NetworkStatus _getNetworkStatus(bool status) {
    return status || kIsWeb ? NetworkStatus.Online : NetworkStatus.Offline;
  }
}
