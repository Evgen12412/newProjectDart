import 'dart:io';

import 'package:auth_dart/auth_dart.dart';
import 'package:conduit_core/conduit_core.dart';



void main(List<String> arguments) async {
  final int port = int.parse(Platform.environment["PORT"] ?? "5431");
  final service = Application<AppService>()..options.port = port;
  await service.start(numberOfInstances: 3, consoleLogging: true);
}


