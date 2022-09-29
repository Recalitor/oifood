// import 'dart:async';
// import 'package:flutter/foundation.dart';
// import 'package:oifood/extensions/list/filter.dart';
// import 'package:oifood/services/auth/crud/crud_exceptions.dart';
// import 'package:path/path.dart' show join;
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';

// class OikadService {
//   Database? _db;

//   //mporei axristo sindeetai me to allapofseis
//   List<DatabaseOifood> _oifood = [];

//   DatabaseUser? _user;

//   static final OikadService _shared = OikadService._sharedInstance();
//   OikadService._sharedInstance() {
//     _oifoodStremController = StreamController<List<DatabaseOifood>>.broadcast(
//       onListen: () {
//         _oifoodStremController.sink.add(_oifood);
//       },
//     );
//   }
//   factory OikadService() => _shared;

//   late final StreamController<List<DatabaseOifood>> _oifoodStremController;

//   //mporei axristo
//   Stream<List<DatabaseOifood>> get allApofaseis =>
//       _oifoodStremController.stream.filter((apofasiColumn) {
//         final currentUser = _user;
//         if (currentUser != null) {
//           return apofasiColumn.id == currentUser.id; //note.id

//         } else {
//           throw UserShouldBeSetBeforeReadingAllApofaseis();
//         }
//       }); //note

//   Future<DatabaseUser> getOrCreateUser({
//     required String email,
//     bool setAsCurrentUser = true,
//   }) async {
//     try {
//       final user = await getUser(email: email);
//       if (setAsCurrentUser) {
//         _user = user;
//       }
//       return user;
//     } on CouldNotFindUser {
//       final createdUser = await createUser(email: email);
//       if (setAsCurrentUser) {
//         _user = createdUser;
//       }
//       return createdUser;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   //den xreiazetai
//   Future<void> _cacheOifood() async {
//     final allApofaseis = await getAllApofaseis();
//     _oifood = allApofaseis.toList();
//     _oifoodStremController.add(_oifood);
//   }

//   Future<DatabaseOifood> updateApofasi({
//     required DatabaseOifood apofasi,
//     required int ap,
//   }) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();

//     //make sure apofasi exists
//     await getApofasi(id: apofasi.id);

//     //update db
//     final updatesCount = await db.update(
//       oifoodTable,
//       {
//         apofasiColumn: ap,
//         isSyncedWithCloudColumn: 0,
//       },
//       where: 'id =?',
//       whereArgs: [apofasi.id],
//     );

//     if (updatesCount == 0) {
//       throw CouldNotUpdateApofasi();
//     } else {
//       final updateApofasi = await getApofasi(id: apofasi.id);
//       _oifood.removeWhere(
//           (apofasitouxristi) => apofasitouxristi.id == updateApofasi.id);
//       _oifood.add(updateApofasi);
//       _oifoodStremController.add(_oifood);
//       return updateApofasi;
//     }
//   }

//   //den xreiazetai
//   Future<Iterable<DatabaseOifood>> getAllApofaseis() async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final apofasi = await db.query(
//       oifoodTable,
//     );
//     return apofasi.map((a) => DatabaseOifood.fromRow(a));
//   }

//   Future<DatabaseOifood> getApofasi({required int id}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final apofasi = await db.query(
//       oifoodTable,
//       limit: 1,
//       where: 'id=?',
//       whereArgs: [id],
//     );

//     if (apofasi.isEmpty) {
//       throw CouldNotFindApofasi();
//     } else {
//       final apofasitouxristi = DatabaseOifood.fromRow(apofasi.first);
//       _oifood.removeWhere((apofasitouxristi) => apofasitouxristi.id == id);
//       _oifood.add(apofasitouxristi);
//       _oifoodStremController.add(_oifood);
//       return apofasitouxristi;
//     }
//   }

//   //den xreiazetai
//   Future<int> deleteAllNotes() async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final numberOfDeletions = await db.delete(oifoodTable);
//     _oifood = [];
//     _oifoodStremController.add(_oifood);
//     return numberOfDeletions;
//   }

//   Future<void> deleteApofasi({required int id}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final deletedCount = await db.delete(
//       oifoodTable,
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//     if (deletedCount == 0) {
//       throw CouldNotDeleteApofasi();
//     } else {
//       //gia streamcontroller

//       _oifood.removeWhere((oifood) => oifood.id == id);
//       _oifoodStremController.add(_oifood);
//     }
//   }

//   Future<DatabaseOifood> createApofasi({required DatabaseUser owner}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     // make sure owner exists in db with correct id
//     final dbUser = await getUser(email: owner.email);
//     if (dbUser != owner) {
//       throw CouldNotFindUser();
//     }

//     const apofasi = 7;
//     //create apofasi
//     final oifoodId = await db.insert(oifoodTable, {
//       userIdColumn: owner.id,
//       apofasiColumn: apofasi,
//       emailColumn: owner.email,
//       isSyncedWithCloudColumn: 1,
//     });

//     final oifood = DatabaseOifood(
//       id: oifoodId,
//       userId: owner.id,
//       apofasi: apofasi,
//       isSyncedWithCloud: true,
//     );
//     //epomenes dio grammes gia to stream controller
//     _oifood.add(oifood);
//     _oifoodStremController.add(_oifood);
//     return oifood;
//   }

//   Future<DatabaseUser> getUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final results = await db.query(
//       userTable,
//       limit: 1,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );

//     if (results.isEmpty) {
//       throw CouldNotFindUser();
//     } else {
//       return DatabaseUser.fromRow(results.first);
//     }
//   }

//   Future<DatabaseUser> createUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final results = await db.query(
//       userTable,
//       limit: 1,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (results.isNotEmpty) {
//       throw UserAlreadyExists();
//     }

//     final userId = await db.insert(userTable, {
//       emailColumn: email.toLowerCase(),
//     });
//     return DatabaseUser(
//       id: userId,
//       email: email,
//     );
//   }

//   Future<void> deleteUser({required String email}) async {
//     await _ensureDbIsOpen();
//     final db = _getDatabaseOrThrow();
//     final deleteCount = await db.delete(
//       userTable,
//       where: 'email = ?',
//       whereArgs: [email.toLowerCase()],
//     );
//     if (deleteCount != 1) {
//       throw CouldNotDeleteUser();
//     }
//   }

//   Database _getDatabaseOrThrow() {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseIsNotOpen();
//     } else {
//       return db;
//     }
//   }

//   Future<void> close() async {
//     final db = _db;
//     if (db == null) {
//       throw DatabaseIsNotOpen();
//     } else {
//       await db.close();
//       _db = null;
//     }
//   }

//   Future<void> _ensureDbIsOpen() async {
//     try {
//       await open();
//     } on DatabaseAlreadyOpenException {
//       //empty
//     }
//   }

//   Future<void> open() async {
//     if (_db != null) {
//       throw DatabaseAlreadyOpenException();
//     }
//     try {
//       final docsPath = await getApplicationDocumentsDirectory();
//       final dbPath = join(docsPath.path, dbName);
//       final db = await openDatabase(dbPath);
//       _db = db;
//       //create the user table
//       await db.execute(createUserTable);
//       //create the oifood table
//       await db.execute(createOifoodTable);
//       //gia na kanoume  cash notes
//       await _cacheOifood();
//     } on MissingPlatformDirectoryException {
//       throw UnableToGetDocumentsDirectory();
//     }
//   }
// }

// @immutable
// class DatabaseUser {
//   final int id;
//   final String email;
//   const DatabaseUser({
//     required this.id,
//     required this.email,
//   });

//   DatabaseUser.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         email = map[emailColumn] as String;

//   @override
//   String toString() => 'Person, ID = $id, email = $email';

//   @override
//   bool operator ==(covariant DatabaseUser other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// //edw gia oifood
// class DatabaseOifood {
//   final int id;
//   final int userId;
//   final int apofasi;
//   final bool isSyncedWithCloud;

//   DatabaseOifood({
//     required this.id,
//     required this.userId,
//     required this.apofasi,
//     required this.isSyncedWithCloud,
//   });

//   DatabaseOifood.fromRow(Map<String, Object?> map)
//       : id = map[idColumn] as int,
//         userId = map[userIdColumn] as int,
//         apofasi = map[apofasiColumn] as int,
//         // isSyncedWithCloud=map[isSyncedWithCloudColumn]as bool;
//         isSyncedWithCloud =
//             (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

//   @override
//   String toString() =>
//       'oifood, ID =$id, userId=$userId, isSyncedWithCloud=$isSyncedWithCloud';

//   @override
//   bool operator ==(covariant DatabaseOifood other) => id == other.id;

//   @override
//   int get hashCode => id.hashCode;
// }

// const dbName = 'oikad';
// const oifoodTable = 'oifood';
// const userTable = 'user';
// const userIdColumn = 'user_id';
// const apofasiColumn = 'apofasi';
// const isSyncedWithCloudColumn = 'is_synced_with_cloud, ';
// const idColumn = 'id';
// const emailColumn = 'email';
// const createUserTable = '''CREATE TABLE  IF NOT EXISTS "user" (
//         "id"	INTEGER NOT NULL,
//         "email"	TEXT NOT NULL UNIQUE,
//         PRIMARY KEY("id" AUTOINCREMENT)
//       ); ''';
// const createOifoodTable = ''' CREATE TABLE IF NOT EXISTS "oifood" (
//         "id"	INTEGER NOT NULL,
//         "user_id"	INTEGER NOT NULL,
//         "apofasi"	INTEGER NOT NULL,
//         "is_synced_with_cloud"	INTEGER DEFAULT 0,
//         PRIMARY KEY("id" AUTOINCREMENT),
//         FOREIGN KEY("user_id") REFERENCES "user"("id")
//       );''';
