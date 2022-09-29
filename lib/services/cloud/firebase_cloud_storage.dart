import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:mynotes/services/cloud/cloud_note.dart';
//import 'package:mynotes/services/cloud/cloud_storage_constants.dart';
//import 'package:mynotes/services/cloud/cloud_storage_exceptions.dart';
import 'package:oifood/services/auth/crud/crud_exceptions.dart';
import 'package:oifood/services/auth/crud/oifood_service.dart';
import 'package:oifood/services/cloud/cloud_storage_constants.dart';
import 'package:oifood/services/cloud/cloud_storage_exceptions.dart';

import 'cloud_note.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('people');

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteApofasi();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      //await notes.doc(documentId).update({textFieldName: text});
      await notes.doc(documentId).update({apofasiColumn: text});
    } catch (e) {
      throw CouldNotUpdateApofasi();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) {
    final allNotes = notes
        //.where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .where(ownerUserId, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudNote.fromSnapshot(doc)));
    return allNotes;
  }

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(
            ownerUserId,
            isEqualTo: ownerUserId,
          )
          .get()
          .then((value) => value.docs.map(
                (doc) => CloudNote.fromSnapshot(doc),
              ));
    } catch (e) {
      throw CouldNotGetAllApofasiException();
    }
  }

  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerUserId: ownerUserId,
      //textFieldName: '',
      intApofasiName: 0,
    });
    final fetchedNote = await document.get();
    return CloudNote(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      //text: '',
      intApofasiName: 0,
    );
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
