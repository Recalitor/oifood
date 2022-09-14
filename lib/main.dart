import 'package:flutter/material.dart';
import 'package:oifood/constants/routes.dart';
import 'package:oifood/services/auth/auth_service.dart';
import 'package:oifood/views/login_view.dart';
import 'package:oifood/views/oifood_view.dart';
import 'package:oifood/views/register_view.dart';
import 'package:oifood/views/verify_email_view.dart';
import 'package:oifood/firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        oifoodRoute: (context) => const OikadView(),
        verifyEmailRoute: (context) => const verifyEmailView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerifiedfalse) {
                return const OikadView();
              } else {
                return const verifyEmailView();
              }
            } else {
              return const LoginView();
            }

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
