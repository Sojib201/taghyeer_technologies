part of 'products_bloc.dart';

enum ProductsStatus { initial, loading, success, failure, loadingMore }

class ProductsState extends Equatable {
  final ProductsStatus status;
  final List<ProductEntity> products;
  final String errorMessage;
  final bool hasReachedMax;
  final int currentSkip;

  const ProductsState({
    this.status = ProductsStatus.initial,
    this.products = const [],
    this.errorMessage = '',
    this.hasReachedMax = false,
    this.currentSkip = 0,
  });

  ProductsState copyWith({
    ProductsStatus? status,
    List<ProductEntity>? products,
    String? errorMessage,
    bool? hasReachedMax,
    int? currentSkip,
  }) {
    return ProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentSkip: currentSkip ?? this.currentSkip,
    );
  }

  @override
  List<Object?> get props =>
      [status, products, errorMessage, hasReachedMax, currentSkip];
}
