part of 'posts_bloc.dart';

enum PostsStatus { initial, loading, success, failure, loadingMore }

class PostsState extends Equatable {
  final PostsStatus status;
  final List<PostEntity> posts;
  final String errorMessage;
  final bool hasReachedMax;
  final int currentSkip;

  const PostsState({
    this.status = PostsStatus.initial,
    this.posts = const [],
    this.errorMessage = '',
    this.hasReachedMax = false,
    this.currentSkip = 0,
  });

  PostsState copyWith({
    PostsStatus? status,
    List<PostEntity>? posts,
    String? errorMessage,
    bool? hasReachedMax,
    int? currentSkip,
  }) {
    return PostsState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      errorMessage: errorMessage ?? this.errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentSkip: currentSkip ?? this.currentSkip,
    );
  }

  @override
  List<Object?> get props =>
      [status, posts, errorMessage, hasReachedMax, currentSkip];
}
