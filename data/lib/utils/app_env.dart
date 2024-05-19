import 'dart:io';

abstract class AppEnv {
  AppEnv._();
  static final String secretKey =
      Platform.environment["SECRET_KEY"] ?? "SECRET_KEY";

  static final String port = Platform.environment["PORT"] ?? "6200";

  static final dbUsername = Platform.environment["DB_USERNAME"] ?? "root";
  static final dbPassword = Platform.environment["DB_PASSWORD"] ?? "root";
  static final dbHost = Platform.environment["DB_HOST"] ?? "localhost";
  static final dbPort = Platform.environment["DB_PORT"] ?? "6201";
  static final dbDatabaseName = Platform.environment["DB_NAME"] ?? "postgres";
}