import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oifood/constants/routes.dart';
import 'package:oifood/helpers/loading/loading_screen.dart';
import 'package:oifood/services/auth/bloc/auth_bloc.dart';
import 'package:oifood/services/auth/bloc/auth_event.dart';
import 'package:oifood/services/auth/bloc/auth_state.dart';
import 'package:oifood/services/auth/firebase_auth_provider.dart';
import 'package:oifood/views/Uis/create_update_xristis_view.dart';
import 'package:oifood/views/forgot_password_view.dart';
import 'package:oifood/views/login_view.dart';
import 'package:oifood/views/Uis/oifood_view.dart';
import 'package:oifood/views/register_view.dart';
import 'package:oifood/views/verify_email_view.dart';
import 'package:path/path.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        //we re supposed to remoive them
        // loginRoute: (context) => const LoginView(),
        // registerRoute: (context) => const RegisterView(),
        // oifoodRoute: (context) => const OikadView(),
        // verifyEmailRoute: (context) => const verifyEmailView(),
        createOrUpdateXristisroute: (context) => const CreateUpdateXristisView()
        //what he did
        //createOrUpdateNoteroute:(context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a momment',
          );
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const OikadView(); //Notesview();
        } else if (state is AuthStateNeedsVerification) {
          return const verifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
//useless fuyture builder now we have b;loc
//   return FutureBuilder(
//     future: AuthService.firebase().initialize(),
//     builder: (context, snapshot) {
//       switch (snapshot.connectionState) {
//         case ConnectionState.done:
//           final user = AuthService.firebase().currentUser;
//           if (user != null) {
//             if (user.isEmailVerifiedfalse) {
//               return const OikadView();
//             } else {
//               return const verifyEmailView();
//             }
//           } else {
//             return const LoginView();
//           }

//         default:
//           return const CircularProgressIndicator();
//       }
//     },
//   );
// }

//counterBloc page
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late final TextEditingController _controller;

//   @override
//   void initState() {
//     _controller = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//         create: ((context) => CounterBloc()),
//         child: Scaffold(
//           appBar: AppBar(
//             title: const Text('testing bloc'),
//           ),
//           body: BlocConsumer<CounterBloc, CounterState>(
//               listener: ((context, state) {
//             _controller.clear();
//           }), builder: (context, state) {
//             final invalidValue =
//                 (state is CounterstateInvalidNumber) ? state.invalidValue : '';
//             return Column(
//               children: [
//                 Text('current value => ${state.value}'),
//                 Visibility(
//                   child: Text('Invalid input: $invalidValue'),
//                   visible: state is! CounterstateInvalidNumber,
//                 ),
//                 TextField(
//                   controller: _controller,
//                   decoration: const InputDecoration(
//                     hintText: 'Enter a number here',
//                   ),
//                   keyboardType: TextInputType.number,
//                 ),
//                 Row(
//                   children: [
//                     TextButton(
//                       onPressed: () {
//                         context
//                             .read<CounterBloc>()
//                             .add(DecrementEvent(_controller.text));
//                       },
//                       child: const Text('-'),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         context
//                             .read<CounterBloc>()
//                             .add(IncrementEvent(_controller.text));
//                       },
//                       child: const Text('+'),
//                     ),
//                   ],
//                 )
//               ],
//             );
//           }),
//         ));
//   }
// }

// @immutable
// abstract class CounterState {
//   final int value;
//   const CounterState(this.value);
// }

// class CounterStateValid extends CounterState {
//   const CounterStateValid(int value) : super(value);
// }

// class CounterstateInvalidNumber extends CounterState {
//   final String invalidValue;
//   const CounterstateInvalidNumber({
//     required this.invalidValue,
//     required int previousValue,
//   }) : super(previousValue);
// }

// @immutable
// abstract class CounterEvent {
//   final String value;
//   const CounterEvent(this.value);
// }

// class IncrementEvent extends CounterEvent {
//   const IncrementEvent(String value) : super(value);
// }

// class DecrementEvent extends CounterEvent {
//   const DecrementEvent(String value) : super(value);
// }

// class CounterBloc extends Bloc<CounterEvent, CounterState> {
//   CounterBloc() : super(const CounterStateValid(0)) {
//     on<IncrementEvent>((event, emit) {
//       final integer = int.tryParse(event.value);
//       if (integer == null) {
//         emit(
//           CounterstateInvalidNumber(
//             invalidValue: event.value,
//             previousValue: state.value,
//           ),
//         );
//       } else {
//         emit(
//           CounterStateValid(state.value + integer),
//         );
//       }
//     });

//     on<DecrementEvent>((event, emit) {
//       final integer = int.tryParse(event.value);
//       if (integer == null) {
//         emit(
//           CounterstateInvalidNumber(
//             invalidValue: event.value,
//             previousValue: state.value,
//           ),
//         );
//       } else {
//         emit(
//           CounterStateValid(state.value - integer),
//         );
//       }
//     });
//   }
// }
