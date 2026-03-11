import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/post_entity.dart';
import '../../../domain/repositories/post_repository.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostRepository postRepository;

  PostsBloc({required this.postRepository}) : super(const PostsState()) {
    on<PostsFetched>(_onPostsFetched);
    on<PostsRefreshed>(_onPostsRefreshed);
  }

  Future<void> _onPostsFetched(
    PostsFetched event,
    Emitter<PostsState> emit,
  ) async {
    if (state.hasReachedMax) return;

    if (state.status == PostsStatus.initial) {
      emit(state.copyWith(status: PostsStatus.loading));
    } else {
      emit(state.copyWith(status: PostsStatus.loadingMore));
    }

    final result = await postRepository.getPosts(
      limit: AppConstants.pageLimit,
      skip: state.currentSkip,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: PostsStatus.failure,
        errorMessage: failure.message,
      )),
      (newPosts) {
        final allPosts = List<PostEntity>.from(state.posts)..addAll(newPosts);
        emit(state.copyWith(
          status: PostsStatus.success,
          posts: allPosts,
          hasReachedMax: newPosts.length < AppConstants.pageLimit,
          currentSkip: state.currentSkip + newPosts.length,
        ));
      },
    );
  }

  Future<void> _onPostsRefreshed(
    PostsRefreshed event,
    Emitter<PostsState> emit,
  ) async {
    emit(const PostsState());
    add(const PostsFetched());
  }
}
