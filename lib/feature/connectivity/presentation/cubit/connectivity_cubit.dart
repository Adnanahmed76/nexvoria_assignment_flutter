import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexvoria_assignment_flutter/feature/connectivity/domain/repositories/connectivity_repository.dart';
import 'package:nexvoria_assignment_flutter/feature/connectivity/presentation/cubit/connectivity_state.dart';

class ConnectivityCubit extends Cubit<ConnectivityStatus> {
  ConnectivityCubit(this._repository) : super(ConnectivityStatus.online) {
    _init();
  }

  final ConnectivityRepository _repository;
  StreamSubscription<bool>? _sub;

  Future<void> _init() async {
    final connected = await _repository.isConnected;
    emit(connected ? ConnectivityStatus.online : ConnectivityStatus.offline);

    _sub = _repository.onConnectivityChanged.listen((connected) {
      emit(connected ? ConnectivityStatus.online : ConnectivityStatus.offline);
    });
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
