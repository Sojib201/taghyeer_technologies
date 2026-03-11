part of 'products_bloc.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();
  @override
  List<Object?> get props => [];
}

class ProductsFetched extends ProductsEvent {
  const ProductsFetched();
}

class ProductsRefreshed extends ProductsEvent {
  const ProductsRefreshed();
}
