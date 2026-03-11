import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/posts/posts_bloc.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/shimmer_list.dart';
import '../../widgets/posts/post_card.dart';
import 'post_detail_page.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<PostsBloc>().add(const PostsFetched());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                context.read<PostsBloc>().add(const PostsRefreshed()),
          ),
        ],
      ),
      body: BlocBuilder<PostsBloc, PostsState>(
        builder: (context, state) {
          switch (state.status) {
            case PostsStatus.initial:
            case PostsStatus.loading:
              return const ShimmerList(isPost: true);

            case PostsStatus.failure:
              if (state.posts.isEmpty) {
                return AppErrorWidget(
                  message: state.errorMessage,
                  onRetry: () =>
                      context.read<PostsBloc>().add(const PostsFetched()),
                );
              }
              return _buildList(state);

            case PostsStatus.success:
            case PostsStatus.loadingMore:
              if (state.posts.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.article_outlined,
                          size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No posts found',
                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                );
              }
              return _buildList(state);
          }
        },
      ),
    );
  }

  Widget _buildList(PostsState state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<PostsBloc>().add(const PostsRefreshed());
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: state.posts.length + (state.hasReachedMax ? 0 : 1),
        itemBuilder: (context, index) {
          if (index >= state.posts.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final post = state.posts[index];
          return PostCard(
            post: post,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PostDetailPage(post: post),
              ),
            ),
          );
        },
      ),
    );
  }
}
