import 'package:flutter/material.dart';
import '../../../domain/entities/post_entity.dart';

class PostDetailPage extends StatelessWidget {
  final PostEntity post;
  const PostDetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Post Detail')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.visibility_outlined,
                    size: 16,
                    color: colorScheme.onSurface.withOpacity(0.5)),
                const SizedBox(width: 4),
                Text(
                  '${post.views} views',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.favorite_border,
                    size: 16, color: Colors.red.shade300),
                const SizedBox(width: 4),
                Text(
                  '${post.reactions} reactions',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: post.tags
                  .map((tag) => Chip(
                        label: Text('#$tag'),
                        padding: EdgeInsets.zero,
                        labelStyle: TextStyle(
                          fontSize: 12,
                          color: colorScheme.primary,
                        ),
                        backgroundColor: colorScheme.primary.withOpacity(0.1),
                        side: BorderSide.none,
                      ))
                  .toList(),
            ),
            const Divider(height: 32),
            Text(
              post.body,
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.6,
                color: colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
