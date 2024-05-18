import 'dart:io';

import 'package:auth_dart/models/user.dart';
import 'package:auth_dart/utils/app_const.dart';
import 'package:auth_dart/utils/app_response.dart';
import 'package:auth_dart/utils/app_utils.dart';
import 'package:conduit_core/conduit_core.dart';

class UserController extends ResourceController {
  final ManagedContext managedContext;

  UserController(this.managedContext);

  @Operation.get()
  Future<Response> getProfile(
  @Bind.header(HttpHeaders.authorizationHeader) String header) async {
    try {
      final id = AppUtils.getIdFromHeader(header);
      final user = await managedContext.fetchObjectWithID<User>(id);
      user?.removePropertiesFromBackingMap(
        [AppConst.accessToken, AppConst.refreshToken]
      );
     return AppResponse.ok(
         message: "Success get profile",
     body: user?.backing.contents);
    } catch (error) {
     return AppResponse.serverError(error, message: "Error get profile");
    }
  }

  @Operation.post()
  Future<Response> updateProfile(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.body() User user) async {
    try {
      final id = AppUtils.getIdFromHeader(header);
      final fUser = await managedContext.fetchObjectWithID<User>(id);
      final qUpdateUser = Query<User>(managedContext)
      ..where((x) => x.id).equalTo(id)
      ..values.username = user.username?? fUser?.username
      ..values.email = user.email?? fUser?.email;
      await qUpdateUser.updateOne();
      final upUser = await managedContext.fetchObjectWithID<User>(id);
      upUser?.removePropertiesFromBackingMap(
          [AppConst.accessToken, AppConst.refreshToken]
      );
      return AppResponse.ok(
          message: "Success update profile",
      body: upUser?.backing.contents);
    } catch (error) {
      return AppResponse.serverError(error, message: "Error update profile");
    }
  }

  @Operation.put()
  Future<Response> updatePassword() async {
    try {
      return AppResponse.ok(message: "update password");
    } catch (error) {
      return AppResponse.serverError(error);
    }
  }
}