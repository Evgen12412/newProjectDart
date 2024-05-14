import 'package:auth_dart/models/response_model.dart';
import 'package:auth_dart/models/user.dart';
import 'package:conduit/conduit.dart';

class AppAuthController extends ResourceController {
  final ManagedContext managedContext;

  AppAuthController(this.managedContext);

  @Operation.post()
  Future<Response> signIn(@Bind.body() User user) async {
    if (user.password == null || user.username == null) {
      return Response.badRequest(body: ResponseModel(
        message: "Fields password and username is required"
      ));
    }

    final User fetchedUser = User();

    return Response.ok(ResponseModel(
      data: {
        "id":fetchedUser.id,
        "refreshToken": fetchedUser.refreshToken,
        "accessToken": fetchedUser.accessToken
      },
      message: "success authentication"
    ).toJson());
  }

  @Operation.put()
  Future<Response> signUp(@Bind.body() User user) async {
    if (user.password == null || user.username == null || user.email == null) {
      return Response.badRequest(body: ResponseModel(
          message: "Fields password and username, email is required"
      ));
    }

    final User fetchedUser = User();

    return Response.ok(ResponseModel(
        data: {
          "id":fetchedUser.id,
          "refreshToken": fetchedUser.refreshToken,
          "accessToken": fetchedUser.accessToken
        },
        message: "success register"
    ).toJson());
  }

  @Operation.post("refresh")
  Future<Response> refreshToken(@Bind.path("refresh") String refreshToken) async {
    final User fetchedUser = User();

    return Response.ok(ResponseModel(
        data: {
          "id":fetchedUser.id,
          "refreshToken": fetchedUser.refreshToken,
          "accessToken": fetchedUser.accessToken
        },
        message: "success update tokens"
    ).toJson());
  }
}