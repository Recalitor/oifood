import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oifood/services/auth/crud/oifood_service.dart';
//import 'package:oifood/services/auth/crud/oifood_service.dart';
import 'package:oifood/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class CloudNote {
  final String documentId;
  final String ownerUserId;
  final int intApofasiName;
  const CloudNote({
    required this.documentId,
    required this.ownerUserId,
    required this.intApofasiName,
  });

  //final String text;

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[userIdColumn],
        //ownerUserId = snapshot.data()[ownerUserIdFieldName],
        //text =snapshot.data()[textFieldName] as String;
        intApofasiName = snapshot.data()[apofasiColumn] as int;
}
