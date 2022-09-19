import 'package:flutter/material.dart';
import 'package:oifood/services/auth/auth_service.dart';
import 'package:oifood/services/auth/crud/oifood_service.dart';
//ti tha vlepei o xristis

//mporei se ola na einai oiffod kai oxi oikadService

class NewXristisView extends StatefulWidget {
  const NewXristisView({super.key});

  @override
  State<NewXristisView> createState() => _NewXristisViewState();
}

class _NewXristisViewState extends State<NewXristisView> {
  DatabaseOifood? _oifood;
  late final OikadService _oikadService;
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    _oikadService = OikadService();
    // _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final apofasi = _oifood;
    if (apofasi == null) {
      return;
    }
    //final text = _textController.text;
    await _oikadService.updateApofasi(
      apofasi: apofasi,
      ap: 3,
      //ap: ap,
    );
  }

  void _setupTextControllerListener() {
    //_textController.removeListener(_textControllerListener);
    //_textController.addListener(_textControllerListener);
  }

  Future<DatabaseOifood> createNewNoteOrApofasi() async {
    final existingNoteorApofasi = _oifood;
    if (existingNoteorApofasi != null) {
      return existingNoteorApofasi;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _oikadService.getUser(email: email);
    return await _oikadService.createApofasi(owner: owner);
  }

  //an patisei back kai gen kanei save
  void _deleteApofasiIfApofasiIsEmpty() {
    final apofasi = _oikadService;
    //if (_textController.text.isEmpty && apofasi != null) {
    if (apofasi != null) {
      // _oikadService.deleteApofasi(id: apofasi.id);
      _oikadService.deleteApofasi(id: 0);
    }
  }

  void _saveNoteOrApofasiIfTextNotEmpty() async {
    final apofasi = _oifood;
    //final text = _textController.text;
    // if (apofasi != null && text.isNotEmpty) {
    if (apofasi != null) {
      await _oikadService.updateApofasi(
        apofasi: apofasi,
        //ap: text,
        ap: 2,
      );
    }
  }

  @override
  void dispose() {
    _deleteApofasiIfApofasiIsEmpty();
    _saveNoteOrApofasiIfTextNotEmpty();
    _textEditingController.dispose(); //_textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Neos Xristis'),
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _oifood = snapshot.data as DatabaseOifood;
              _setupTextControllerListener();
              return TextField(
                //controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'grapse tin dikaiologia sou...',
                ),
              );

            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
