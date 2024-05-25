import 'dart:io';

import 'package:data/utils/app_response.dart';
import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/post.dart';
import 'package:data/models/author.dart';

class PostController extends ResourceController {
  final ManagedContext managedContext;

  PostController(this.managedContext);

  @Operation.get()
  Future<Response> getPosts() async {
    try {
      // final id = AppUtils.getIdFromHeader(header);
      // final user = await managedContext.fetchObjectWithID<User>(id);
      // user?.removePropertiesFromBackingMap(
      //   [AppConst.accessToken, AppConst.refreshToken]
      // );
     return AppResponse.ok(
         message: "Success get posts");
    } catch (error) {
     return AppResponse.serverError(error, message: "Error get posts");
    }
  }

}