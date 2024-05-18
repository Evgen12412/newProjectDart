import 'dart:io';

import 'package:auth_dart/controllers/token_controller.dart';
import 'package:auth_dart/controllers/user_controller.dart';
import 'package:auth_dart/utils/app_env.dart';
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

    return PostgreSQLPersistentStore(
       AppEnv.dbUsername,
        AppEnv.dbPassword,
        AppEnv.dbHost,
        int.tryParse(AppEnv.dbPort),
        AppEnv.dbDatabaseName
    );
  }
}

