import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/products/products_bloc.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/shimmer_list.dart';
import '../../widgets/products/product_card.dart';
import 'product_detail_page.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
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
      context.read<ProductsBloc>().add(const ProductsFetched());
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
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                context.read<ProductsBloc>().add(const ProductsRefreshed()),
          ),
        ],
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          switch (state.status) {
            case ProductsStatus.initial:
            case ProductsStatus.loading:
              return const ShimmerList();

            case ProductsStatus.failure:
              if (state.products.isEmpty) {
                return AppErrorWidget(
                  message: state.errorMessage,
                  onRetry: () => context
                      .read<ProductsBloc>()
                      .add(const ProductsFetched()),
                );
              }
              return _buildList(state);

            case ProductsStatus.success:
            case ProductsStatus.loadingMore:
              if (state.products.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag_outlined,
                          size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No products found',
                          style: TextStyle(
                              fontSize: 16, color: Colors.grey)),
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

  Widget _buildList(ProductsState state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProductsBloc>().add(const ProductsRefreshed());
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: state.products.length + (state.hasReachedMax ? 0 : 1),
        itemBuilder: (context, index) {
          if (index >= state.products.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final product = state.products[index];
          return ProductCard(
            product: product,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailPage(product: product),
              ),
            ),
          );
        },
      ),
    );
  }
}
