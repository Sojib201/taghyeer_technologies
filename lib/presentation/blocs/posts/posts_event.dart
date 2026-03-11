part of 'posts_bloc.dart';

abstract class PostsEvent extends Equatable {
  const PostsEvent();
  @override
  List<Object?> get props => [];
}

class PostsFetched extends PostsEvent {
  const PostsFetched();
}

class PostsRefreshed extends PostsEvent {
  const PostsRefreshed();
}
