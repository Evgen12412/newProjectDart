import 'dart:io';

import 'package:conduit/conduit.dart';

class AppService extends ApplicationChannel {
  late final ManagedContext managedContext;

  @override
  Future prepare() {
    final persistentStore = _initDatabase();
    managedContext = ManagedContext(
        ManagedDataModel.fromCurrentMirrorSystem(),
        persistentStore);
    return super.prepare();
  }

  @override
  // TODO: implement entryPoint
  Controller get entryPoint => Router();

  PostgreSQLPersistentStore _initDatabase() {
    final username = Platform.environment["DB_USERNAME"] ?? "root";
    final password = Platform.environment["DB_PASSWORD"] ?? "root";
    final host = Platform.environment["DB_HOST"] ?? "localhost";
    final port = int.parse(Platform.environment["DB_PORT"] ?? "5433");
    final databaseName = Platform.environment["DB_NAME"] ?? "postgres";
    return PostgreSQLPersistentStore(
        username,
        password,
        host,
        port,
        databaseName
    );
  }
}

