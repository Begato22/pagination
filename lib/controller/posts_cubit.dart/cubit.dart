import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination/controller/posts_cubit.dart/states.dart';
import 'package:pagination/model/post.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(PostInitial());

  List<Post> posts = [];
  bool isFullyLoaded = false;

  Future<void> fetchPosts() async {
    if (isFullyLoaded) return;
    emit(PostLoading());
    try {
      final response = await Dio().get('https://jsonplaceholder.typicode.com/posts');

      if (response.statusCode == 200) {
        final List<Post> pts = (response.data as List).map((json) => Post.fromJson(json)).toList();
        if (posts.length == pts.length) {
          isFullyLoaded = true;
          emit(PostLoaded(posts));
          return;
        }
        if ((posts.length - pts.length).abs() % 10 == 0) {
          posts = posts + pts.getRange(posts.isEmpty ? 0 : posts.length, posts.length + 10).toList();
        } else {
          posts = posts + pts.getRange(posts.length, pts.length % 10).toList();
        }

        emit(PostLoaded(posts));
      } else {
        emit(PostError('Failed to load posts: ${response.statusCode}'));
      }
    } catch (e) {
      emit(PostError('Error occurred: $e'));
    }
  }
}
