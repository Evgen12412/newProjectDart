import 'dart:io';

import 'package:auth_dart/models/response_model.dart';
import 'package:auth_dart/models/user.dart';
import 'package:auth_dart/utils/app_utils.dart';
import 'package:conduit/conduit.dart';
import 'package:conduit_core/conduit_core.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class AppAuthController extends ResourceController {
  final ManagedContext managedContext;

  AppAuthController(this.managedContext);

  @Operation.post()
  Future<Response> signIn(@Bind.body() User user) async {
    if (user.password == null || user.username == null) {
      return Response.badRequest(body: ResponseModelAuth(
        message: "Fields password and username is required"
      ));
    }
    try {
      final qFindUser = Query<User>(managedContext)
        ..where((table) => table.username).equalTo(user.username)
        ..returningProperties((table) =>
        [
          table.id,
          table.salt,
          table.hashPassword
        ]);
      final findUser = await qFindUser.fetchOne();
      if (findUser == null) {
          throw QueryException.input("User not found", []);
      }
      final requestHashPassword = generatePasswordHash(user.password?? "", findUser.salt ?? "");

      if (requestHashPassword == findUser.hashPassword) {
        await updateTokens(findUser.id ?? -1, managedContext);
        final newUser = await managedContext.fetchObjectWithID<User>(findUser.id);
        return Response.ok(ResponseModelAuth(data: newUser?.backing.contents,
        message: "success auth"));
      } else {
        throw QueryException.input("password not true", []);
      }
    } on QueryException catch (error) {
      return Response.serverError(body: ResponseModelAuth(message: error.message));
    }
  }

  @Operation.put()
  Future<Response> signUp(@Bind.body() User user) async {
    if (user.password == null || user.username == null || user.email == null) {
      return Response.badRequest(body: ResponseModelAuth(
          message: "Fields password and username, email is required"
      ));
    }

    final salt = generateRandomSalt();
    final hashPassword = generatePasswordHash(user.password ??"", salt);

    try {
      late final int id;
      await managedContext.transaction((transaction) async {
        final qCreateUser = Query<User>(transaction)
            ..values.username = user.username
            ..values.email = user.email
            ..values.salt = salt
            ..values.hashPassword = hashPassword;
        final createdUser = await qCreateUser.insert();
        id = createdUser.asMap()["id"];
        await updateTokens(id, transaction);
      });
      final userData = await managedContext.fetchObjectWithID<User>(id);
      return Response.ok(
          ResponseModelAuth(data: userData?.backing.contents,
          message: "success register"));
    } on QueryException catch (error) {
      return Response.serverError(body: ResponseModelAuth(message: error.message));
    }

  }

  Future<void> updateTokens(int id, ManagedContext transaction) async {
    final Map<String, dynamic> tokens = _getTokens(id);
    final qUpdateToken = Query<User>(transaction)
      ..where((user) => user.id).equalTo(id)
      ..values.accessToken = tokens["access"]
      ..values.refreshToken = tokens["refresh"];
    await qUpdateToken.updateOne();
  }

  @Operation.post("refresh")
  Future<Response> refreshToken(@Bind.path("refresh") String refreshToken) async {

    try {
      final id = AppUtils.getIdFromToken(refreshToken);
      final user = await managedContext.fetchObjectWithID<User>(id);
      if (user?.refreshToken != refreshToken) {
        return Response.unauthorized(body: ResponseModelAuth(message: "Invalid refresh token"))
      } else {
        await updateTokens(id, managedContext);
        final user = await managedContext.fetchObjectWithID<User>(id);
        return Response.ok(ResponseModelAuth(data: user?.backing.contents,
            message: "success update tokens"));
      }


    } on QueryException catch (error) {
      return Response.serverError(body: ResponseModelAuth(message: error.message));
    }
  }

  Map<String, dynamic> _getTokens(int id) {
    final key = Platform.environment["SECRET_KEY"] ?? "SECRET_KEY";
    final accessClaimSet = JwtClaim(
      maxAge: Duration(hours: 1),
      otherClaims: {"id":id}
    );
    final refreshClaimSet = JwtClaim(
        otherClaims: {"id":id}
    );
    final tokens = <String, dynamic>{};
    tokens["access"] = issueJwtHS256(accessClaimSet, key);
    tokens["refresh"] = issueJwtHS256(refreshClaimSet, key);
    return tokens;
  }
}