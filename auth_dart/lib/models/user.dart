import 'package:conduit/conduit.dart';
import 'package:conduit_core/conduit_core.dart';

class User extends ManagedObject<_User> implements _User {}

class _User {
  @primaryKey
  int? id;
  @Column(unique: true, indexed: true)
  String? username;
  @Column(unique: true, indexed: true)
  String? email;
  // данные можем получить но хранить не будем
  @Serialize(input: true, output: false)
  String? password;
  @Column(nullable: true)
  String? accessToken;
  @Column(nullable: true)
  String? refreshToken;

  // хранить можем а получить нет
  @Column(omitByDefault: true)
  String? salt;
  @Column(omitByDefault: true)
  String? hashPassword;
}