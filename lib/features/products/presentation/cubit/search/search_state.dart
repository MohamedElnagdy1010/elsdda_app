import 'package:equatable/equatable.dart';
import 'package:sufra_app/features/products/domain/entities/product_entity.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchWaiting extends SearchState {
  const SearchWaiting();
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SearchLoaded extends SearchState {
  final List<ProductEntity> products;
  final String query;

  const SearchLoaded({required this.products, required this.query});

  @override
  List<Object?> get props => [products, query];
}

class SearchEmpty extends SearchState {
  final String query;

  const SearchEmpty(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchFailure extends SearchState {
  final String message;

  const SearchFailure(this.message);

  @override
  List<Object?> get props => [message];
}
