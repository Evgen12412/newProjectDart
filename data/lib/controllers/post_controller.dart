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
        final qCreateAuthor = Query<Author>(managedContext)..values.id = id;
        await qCreateAuthor.insert();
      }
      final qCreatePost = Query<Post>(managedContext)
        ..values.author?.id = id
        ..values.content = post.content;
      await qCreatePost.insert();
      return AppResponse.ok(message: "Success create posts");
    } catch (error) {
      return AppResponse.serverError(error, message: "Error create posts");
    }
  }

  @Operation.get("id")
  Future<Response> getPosts(
    @Bind.header(HttpHeaders.authorizationHeader) String header,
    @Bind.path("id") int id,
  ) async {
    try {
      final currentAuthorId = AppUtils.getIdFromHeader(header);
      final post = await managedContext.fetchObjectWithID<Post>(id);

      if (post == null) {
        return AppResponse.ok(message: "Post not found");
      }

      if (post.author?.id != currentAuthorId) {
        return AppResponse.ok(message: "Access denied");
      }
      post.backing.removeProperty("author");
      return AppResponse.ok(
          body: post.backing.contents, message: "Success get posts");
    } catch (error) {
      return AppResponse.serverError(error, message: "Error get posts");
    }
  }

  @Operation.delete("id")
  Future<Response> deletePosts(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.path("id") int id,
      ) async {
    try {
      final currentAuthorId = AppUtils.getIdFromHeader(header);
      final post = await managedContext.fetchObjectWithID<Post>(id);

      if (post == null) {
        return AppResponse.ok(message: "Post not found");
      }

      if (post.author?.id != currentAuthorId) {
        return AppResponse.ok(message: "Access denied");
      }

      final qDeletePost = Query<Post>(managedContext)
      ..where((x) => x.id).equalTo(id);
      await qDeletePost.delete();

      return AppResponse.ok(
           message: "Success delete post");
    } catch (error) {
      return AppResponse.serverError(error, message: "Error delete post");
    }
  }
}
