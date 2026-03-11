import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerList extends StatelessWidget {
  final bool isPost;
  const ShimmerList({super.key, this.isPost = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey.shade700 : Colors.grey.shade300;
    final highlightColor = isDark ? Colors.grey.shade500 : Colors.grey.shade100;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: isPost ? _PostShimmer() : _ProductShimmer(),
          ),
        ),
      ),
    );
  }
}

class _ProductShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 14, color: Colors.white,
                  margin: const EdgeInsets.only(right: 40)),
              const SizedBox(height: 6),
              Container(
                  height: 12, color: Colors.white,
                  margin: const EdgeInsets.only(right: 80)),
              const SizedBox(height: 12),
              Container(
                  height: 16, color: Colors.white,
                  margin: const EdgeInsets.only(right: 100)),
            ],
          ),
        ),
      ],
    );
  }
}

class _PostShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 16, color: Colors.white),
        const SizedBox(height: 6),
        Container(height: 14, color: Colors.white,
            margin: const EdgeInsets.only(right: 60)),
        const SizedBox(height: 12),
        Container(height: 12, color: Colors.white),
        const SizedBox(height: 4),
        Container(height: 12, color: Colors.white,
            margin: const EdgeInsets.only(right: 40)),
        const SizedBox(height: 4),
        Container(height: 12, color: Colors.white,
            margin: const EdgeInsets.only(right: 80)),
      ],
    );
  }
}
