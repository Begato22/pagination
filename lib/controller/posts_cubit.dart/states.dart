import 'package:pagination/model/post.dart';

class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<Post> posts;

  PostLoaded(this.posts);
}

class PostError extends PostState {
  final String error;

  PostError(this.error);
}
