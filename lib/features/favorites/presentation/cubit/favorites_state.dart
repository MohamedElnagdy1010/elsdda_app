import 'package:equatable/equatable.dart';
import 'package:sufra_app/features/products/domain/entities/product_entity.dart';

sealed class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

class FavoritesLoaded extends FavoritesState {
  final List<ProductEntity> products;
  final Set<String> favoriteIds;

  const FavoritesLoaded({required this.products, required this.favoriteIds});

  @override
  List<Object?> get props => [products, favoriteIds];
}

class FavoritesFailure extends FavoritesState {
  final String message;

  const FavoritesFailure(this.message);

  @override
  List<Object?> get props => [message];
}
