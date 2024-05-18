import 'package:auth_dart/utils/app_response.dart';
import 'package:conduit_core/conduit_core.dart';

class UserController extends ResourceController {
  final ManagedContext managedContext;

  UserController(this.managedContext);

  @Operation.get()
  Future<Response> getProfile() async {
    try {
     return AppResponse.ok(message: "get profile");
    } catch (error) {
     return AppResponse.serverError(error);
    }
  }

  @Operation.post()
  Future<Response> updateProfile() async {
    try {
      return AppResponse.ok(message: "update profile");
    } catch (error) {
      return AppResponse.serverError(error);
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