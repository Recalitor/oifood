import 'package:flutter/material.dart';
import 'package:oifood/services/auth/auth_service.dart';
import 'package:oifood/utilities/dialogs/generics/get_arguments.dart';
import 'package:oifood/services/cloud/cloud_note.dart';
import 'package:oifood/services/cloud/cloud_storage_exceptions.dart';
import 'package:oifood/services/cloud/firebase_cloud_storage.dart';

import '../../utilities/dialogs/cannot_share_empty_note_dialog.dart';
//ti tha vlepei o xristis

//mporei se ola na einai oiffod kai oxi oikadService

class CreateUpdateXristisView extends StatefulWidget {
  const CreateUpdateXristisView({super.key});

  @override
  State<CreateUpdateXristisView> createState() =>
      _CreateUpdateXristisViewState();
}

class _CreateUpdateXristisViewState extends State<CreateUpdateXristisView> {
  CloudNote? _oifood;
  late final FirebaseCloudStorage _oikadService;
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    _oikadService = FirebaseCloudStorage();
    // _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final apofasi = _oifood;
    if (apofasi == null) {
      return;
    }
    //final text = _textController.text;
    await _oikadService.updateNote(
      documentId: apofasi.documentId,
      text: 'agaien',
    );
  }

  void _setupTextControllerListener() {
    //_textController.removeListener(_textControllerListener);
    //_textController.addListener(_textControllerListener);
  }

  Future<CloudNote> createOrGetExistingApofasi(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();

    if (widgetNote != null) {
      _oifood = widgetNote;
      //_textController.text = widgetNote.apofasi;
      return widgetNote;
    }

    final existingNoteorApofasi = _oifood;
    if (existingNoteorApofasi != null) {
      return existingNoteorApofasi;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;

    final newApofasi = await _oikadService.createNewNote(ownerUserId: userId);
    _oifood = newApofasi; // for storing the apofasi
    return newApofasi;
  }

  //an patisei back kai gen kanei save
  void _deleteApofasiIfApofasiIsEmpty() {
    final apofasi = _oifood;
    //if (_textController.text.isEmpty && apofasi != null) {
    if (apofasi != null) {
      _oikadService.deleteNote(documentId: apofasi.documentId);
    }
  }

  void _saveNoteOrApofasiIfTextNotEmpty() async {
    final apofasi = _oifood;
    //final text = _textController.text;
    // if (apofasi != null && text.isNotEmpty) {
    if (apofasi != null) {
      await _oikadService.updateNote(
        documentId: apofasi.documentId,
        text: 'nothisdf',
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
        actions: [
          IconButton(
            onPressed: () {
              // final text = _textController.text;
              // if(_note==null|| text.isEmpty){
              //   await showCannotShareEmptyNoteDialog(context);
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: FutureBuilder(
        future: createOrGetExistingApofasi(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
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
