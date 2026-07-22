abstract class ConnectivityRepository {
  Stream<bool> get onConnectivityChanged;
  Future<bool> get isConnected;
}
