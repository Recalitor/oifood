import 'package:flutter/material.dart';
import 'package:oifood/services/auth/auth_service.dart';
import 'package:oifood/services/auth/crud/oifood_service.dart';
import 'package:path/path.dart';
//import 'package:oifood/services/auth/crud/oifood_service.dart';
import '../../constants/routes.dart';
import '../../enums/menu_action.dart';

class OikadView extends StatefulWidget {
  //const OikadView({super.key});
  const OikadView({Key? key}) : super(key: key);

  @override
  State<OikadView> createState() => _OikadViewState();
}

class _OikadViewState extends State<OikadView> {
  //late final OifoodService _oifoodService;
  late final OikadService _oifoodService;
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _oifoodService = OikadService();
    super.initState();
  }

  @override
  void dispose() {
    _oifoodService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OiFood'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(newXristisRoute);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await AuthService.firebase().logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  }
              }
              // devtools.log(value.toString());
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log out'),
                )
              ];
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: _oifoodService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _oifoodService.allApofaseis,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return const Text('Waiting for all notes...');
                    default:
                      return const CircularProgressIndicator();
                  }
                },
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Log out'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
