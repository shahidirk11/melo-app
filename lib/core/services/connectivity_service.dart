import 'dart:async';

enum NetworkStatus {
  online,
  offline,
}

/// Abstract connectivity service for local-first Melo.
/// Melo is designed from the ground up to operate completely offline
/// without requiring internet connectivity for any practice features.
abstract class ConnectivityService {
  Stream<NetworkStatus> get statusStream;
  NetworkStatus get currentStatus;
  bool get isOnline;
  bool get isOffline;
  void setNetworkStatus(NetworkStatus status);
  void dispose();
}

class OfflineFirstConnectivityService implements ConnectivityService {
  OfflineFirstConnectivityService({
    NetworkStatus initialStatus = NetworkStatus.online,
  }) : _status = initialStatus {
    _controller = StreamController<NetworkStatus>.broadcast();
  }

  NetworkStatus _status;
  late final StreamController<NetworkStatus> _controller;

  @override
  Stream<NetworkStatus> get statusStream => _controller.stream;

  @override
  NetworkStatus get currentStatus => _status;

  @override
  bool get isOnline => _status == NetworkStatus.online;

  @override
  bool get isOffline => _status == NetworkStatus.offline;

  @override
  void setNetworkStatus(NetworkStatus status) {
    if (_status != status) {
      _status = status;
      if (!_controller.isClosed) {
        _controller.add(_status);
      }
    }
  }

  @override
  void dispose() {
    _controller.close();
  }
}
