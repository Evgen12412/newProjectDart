import 'dart:io';

import 'package:auth_dart/controllers/token_controller.dart';
import 'package:auth_dart/controllers/user_controller.dart';
import 'package:conduit_core/conduit_core.dart';
import 'package:conduit_postgresql/conduit_postgresql.dart';

import 'controllers/auth_controller.dart';

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
  Controller get entryPoint => Router()
    ..route("token/[:refresh]").link(
        () => AppAuthController(managedContext),
  )
  ..route("user")
      .link(() => TokenController())!
      .link(() => UserController(managedContext));


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

