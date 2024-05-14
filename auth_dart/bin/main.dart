import 'dart:io';

import 'package:auth_dart/auth.dart';
import 'package:conduit/conduit.dart';

void main(List<String> arguments) async {
  final int port = (Platform.environment["PORT"] ?? "5431") as int;
  final service = Application<AppService>()..options.port = port;
  await service.start(numberOfInstances: 3, consoleLogging: true);
}


