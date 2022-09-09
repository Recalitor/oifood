import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oifood/firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  //const LoginView({Key? key}):super(key:key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  //to ekana
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
  //mexri edw

  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
}
