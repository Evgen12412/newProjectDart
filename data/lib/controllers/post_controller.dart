import 'dart:io';

import 'package:data/utils/app_response.dart';
import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/post.dart';
import 'package:data/models/author.dart';

import '../utils/app_utils.dart';

class PostController extends ResourceController {
  final ManagedContext managedContext;

  PostController(this.managedContext);

  @Operation.post()
  Future<Response> createPost(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.body() Post post,
      ) async {
    try {
      final id = AppUtils.getIdFromHeader(header);
      final author = await managedContext.fetchObjectWithID<Author>(id);
      if (author == null) {
        final qCreateAuthor = Query<Author>(managedContext)
            ..values.id = id;
        await qCreateAuthor.insert();
      }
      final qCreatePost = Query<Post>(managedContext)
      ..values.author?.id = id
      ..values.content = post.content;
      await qCreatePost.insert();
      return AppResponse.ok(
          message: "Success create posts");
    } catch (error) {
      return AppResponse.serverError(error, message: "Error create posts");
    }
  }

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