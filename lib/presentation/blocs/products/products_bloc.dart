import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/repositories/product_repository.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductRepository productRepository;

  ProductsBloc({required this.productRepository})
      : super(const ProductsState()) {
    on<ProductsFetched>(_onProductsFetched);
    on<ProductsRefreshed>(_onProductsRefreshed);
  }

  Future<void> _onProductsFetched(
    ProductsFetched event,
    Emitter<ProductsState> emit,
  ) async {
    if (state.hasReachedMax) return;

    if (state.status == ProductsStatus.initial) {
      emit(state.copyWith(status: ProductsStatus.loading));
    } else {
      emit(state.copyWith(status: ProductsStatus.loadingMore));
    }

    final result = await productRepository.getProducts(
      limit: AppConstants.pageLimit,
      skip: state.currentSkip,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: ProductsStatus.failure,
        errorMessage: failure.message,
      )),
      (newProducts) {
        final allProducts = List<ProductEntity>.from(state.products)
          ..addAll(newProducts);
        emit(state.copyWith(
          status: ProductsStatus.success,
          products: allProducts,
          hasReachedMax: newProducts.length < AppConstants.pageLimit,
          currentSkip: state.currentSkip + newProducts.length,
        ));
      },
    );
  }

  Future<void> _onProductsRefreshed(
    ProductsRefreshed event,
    Emitter<ProductsState> emit,
  ) async {
    emit(const ProductsState());
    add(const ProductsFetched());
  }
}
