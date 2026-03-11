import '../../domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.id,
    required super.title,
    required super.body,
    required super.tags,
    required super.reactions,
    required super.views,
    required super.userId,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      reactions: json['reactions'] is int
          ? json['reactions']
          : (json['reactions']?['likes'] ?? 0),
      views: json['views'] ?? 0,
      userId: json['userId'] ?? 0,
    );
  }
}
