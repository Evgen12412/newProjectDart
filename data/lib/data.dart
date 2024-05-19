import 'dart:io' as data;

import 'package:conduit_core/conduit_core.dart';
import 'package:conduit_postgresql/conduit_postgresql.dart';
import 'package:data/utils/app_env.dart';

import 'controllers/post_controller.dart';
import 'controllers/token_controller.dart';


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
    ..route("posts/[:id]")
        .link(() => TokenController())!
        .link(() => PostController(managedContext),);


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

