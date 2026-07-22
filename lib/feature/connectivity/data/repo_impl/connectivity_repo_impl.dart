import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:nexvoria_assignment_flutter/feature/connectivity/domain/repositories/connectivity_repository.dart';

class ConnectivityRepositoryImpl implements ConnectivityRepository {
  ConnectivityRepositoryImpl(this._connectivity);
  final Connectivity _connectivity;

  bool _hasConnection(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);

  @override
  Stream<bool> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged.map(_hasConnection);

  @override
  Future<bool> get isConnected async =>
      _hasConnection(await _connectivity.checkConnectivity());
}
