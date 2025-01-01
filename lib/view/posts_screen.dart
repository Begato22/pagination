import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination/controller/posts_cubit.dart/cubit.dart';
import 'package:pagination/controller/posts_cubit.dart/states.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  late PostCubit _cubit;
  late ScrollController _scrollController;
  @override
  void initState() {
    _cubit = PostCubit();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) _cubit.fetchPosts();
    });
    super.initState();
  }

  @override
  void dispose() {
    _cubit.close();
    _scrollController.removeListener(() {});
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostCubit>(
      create: (context) => _cubit..fetchPosts(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Posts'),
          actions: [
            BlocBuilder<PostCubit, PostState>(
              builder: (context, state) {
                return Text('Posts Count: ${_cubit.posts.length}');
              },
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: BlocBuilder<PostCubit, PostState>(
          builder: (context, state) {
            if (_cubit.posts.isEmpty && (state is PostInitial || state is PostLoading)) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PostError) {
              return Center(child: Text(state.error));
            } else {
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _cubit.posts.length,
                  itemBuilder: (context, index) {
                    final post = _cubit.posts[index];
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          margin: EdgeInsets.only(bottom: index == _cubit.posts.length - 1 ? 0 : 10),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            // leading: Text(post.id.toString()),
                            title: Text(post.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(post.body),
                          ),
                        ),
                        if (!_cubit.isFullyLoaded && index == _cubit.posts.length - 1) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 30),
                            child: CircularProgressIndicator(),
                          )
                        ],
                      ],
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
