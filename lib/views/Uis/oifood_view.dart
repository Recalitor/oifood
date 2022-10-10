import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import 'package:oifood/services/auth/auth_service.dart';
import 'package:oifood/services/auth/bloc/auth_bloc.dart';
import 'package:oifood/services/auth/bloc/auth_event.dart';
import 'package:oifood/services/cloud/cloud_note.dart';
import 'package:oifood/services/cloud/firebase_cloud_storage.dart';
import 'package:oifood/views/Uis/oifood_list_view.dart';
//import 'package:oifood/services/auth/crud/oifood_service.dart';
import '../../constants/routes.dart';
import '../../enums/menu_action.dart';
import '../../utilities/dialogs/logout_dialog.dart';

class OikadView extends StatefulWidget {
  const OikadView({super.key});
  //const OikadView({Key? key}) : super(key: key);

  @override
  //egw eixa to panw
  //State<OikadView> createState() => _OikadViewState();
  _OikadViewState createState() => _OikadViewState();
}

class _OikadViewState extends State<OikadView> {
  //late final OifoodService _oifoodService;
  late final FirebaseCloudStorage _oifoodService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _oifoodService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OiFood'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createOrUpdateXristisroute);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    //await AuthService.firebase().logOut();
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                    // Navigator.of(context).pushNamedAndRemoveUntil(
                    //   loginRoute,
                    //   (_) => false,
                    // );
                  }
              }
              // devtools.log(value.toString());
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log out'),
                ),
              ];
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: _oifoodService.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allApofaseis = snapshot.data as Iterable<CloudNote>;
                return OifoodListView(
                  apofaseis: allApofaseis,
                  onDeleteApofasi: (oifood) async {
                    await _oifoodService.deleteNote(
                        documentId: oifood.documentId);
                  },
                  onTap: (oifood) {
                    Navigator.of(context).pushNamed(createOrUpdateXristisroute,
                        arguments: oifood);
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }

            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
