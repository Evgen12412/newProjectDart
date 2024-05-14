import 'package:auth_dart/models/response_model.dart';
import 'package:conduit/conduit.dart';

class AppAuthController extends ResourceController {
  final ManagedContext managedContext;

  AppAuthController(this.managedContext);

  @Operation.post()
  Future<Response> signIn() async {
    return Response.ok(ResponseModel(
      data: {
        "id":"1",
        "refreshToken": "refreshToken",
        "accessToken": "accessToken"
      },
      message: "sign in ok"
    ).toJson());
  }

  @Operation.put()
  Future<Response> signUp() async {
    return Response.ok(ResponseModel(
        data: {
          "id":"1",
          "refreshToken": "refreshToken",
          "accessToken": "accessToken"
        },
        message: "sign up ok"
    ).toJson());
  }

  @Operation.post("refresh")
  Future<Response> refreshToken() async {
    return Response.unauthorized(body: ResponseModel(error: "token is not valid").toJson());
  }
}