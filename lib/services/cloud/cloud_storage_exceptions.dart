class cloudStorageException implements Exception {
  const cloudStorageException();
}

//C in CRUD
class CouldNotCreateApofasiException extends cloudStorageException {}

//R in CRUD
class CouldNotGetAllApofasiException extends cloudStorageException {}

//U in CRUD
class CouldNotUpdateApofasiException extends cloudStorageException {}

//D in CRUD
class CouldNotDeleteApofasiException extends cloudStorageException {}
