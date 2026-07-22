import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexvoria_assignment_flutter/feature/connectivity/presentation/cubit/connectivity_state.dart';
import '../cubit/connectivity_cubit.dart';

class ConnectivityBanner extends StatelessWidget {
  const ConnectivityBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityCubit, ConnectivityStatus>(
      builder: (context, status) {
        if (status == ConnectivityStatus.online) return const SizedBox.shrink();
        return Container(
          width: double.infinity,
          color: Colors.redAccent,
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: const Text(
            'Offline — changes will sync when back online',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        );
      },
    );
  }
}
