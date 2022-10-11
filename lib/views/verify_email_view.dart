import 'package:flutter/material.dart';
import 'package:oifood/constants/routes.dart';
import 'package:oifood/services/auth/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oifood/services/auth/bloc/auth_bloc.dart';
import 'package:oifood/services/auth/bloc/auth_event.dart';

class verifyEmailView extends StatefulWidget {
  const verifyEmailView({Key? key}) : super(key: key);

  @override
  State<verifyEmailView> createState() => _verifyEmailViewState();
}

class _verifyEmailViewState extends State<verifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify email'),
      ),
      body: Column(
        children: [
          const Text(
              "we've sent oyu an email verification . Please open it to verify youre account @"),
          const Text(
              "if oyu havent get the email verification press button bellow "),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(
                    const AuthEventSendEmailVerification(),
                  );
            },
            child: const Text('Send email verification'),
          ),
          TextButton(
            onPressed: () async {
              context.read<AuthBloc>().add(
                    const AuthEventLogOut(),
                  );
            },
            child: const Text('Restart'),
          )
        ],
      ),
    );
  }
}
