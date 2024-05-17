import 'package:auth_dart/models/response_model.dart';
import 'package:conduit_core/conduit_core.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class AppResponse extends Response {
  AppResponse.serverError(dynamic error, {String? message}) : super.serverError(
    body: _getResponseModel(error, message)
  );

  static ResponseModelAuth _getResponseModel(error, String? message) {
    if (error is QueryException) {
      return ResponseModelAuth(
        error:  error.toString(),
        message: message??error.message
      );
    }

    if (error is JwtException) {
      return ResponseModelAuth(
          error:  error.toString(),
          message: message??error.message
      );
    }
    return ResponseModelAuth(
        error:  error.toString(),
        message: message??"Unknown error"
    );
  }
  AppResponse.ok({dynamic body, String? message}) : super.ok(
      ResponseModelAuth(data: body, message: message)
  );
}