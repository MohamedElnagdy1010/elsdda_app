import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:sufra_app/features/authentication/domain/use_cases/login_use_case.dart';
import 'package:sufra_app/features/authentication/domain/use_cases/logout_use_case.dart';
import 'package:sufra_app/features/authentication/presentation/cubit/login/login_cubit.dart';
import 'package:sufra_app/features/authentication/presentation/cubit/logout/logout_cubit.dart';

import 'package:sufra_app/features/orders/data/data_sources/orders_remote_data_source.dart';
import 'package:sufra_app/features/orders/data/repositories/orders_repository_impl.dart';
import 'package:sufra_app/features/orders/domain/repositories/orders_repository.dart';
import 'package:sufra_app/features/orders/domain/use_cases/create_order_use_case.dart';
import 'package:sufra_app/features/orders/domain/use_cases/get_user_orders_use_case.dart';
import 'package:sufra_app/features/orders/presentation/cubit/orders/orders_cubit.dart';
import 'package:sufra_app/features/products/data/data_sources/products_remote_data_source.dart';
import 'package:sufra_app/features/products/data/repositories/products_repository_impl.dart';
import 'package:sufra_app/features/products/domain/repositories/products_repository.dart';
import 'package:sufra_app/features/products/domain/use_cases/get_categories_use_case.dart';
import 'package:sufra_app/features/products/domain/use_cases/get_featured_products_use_case.dart';
import 'package:sufra_app/features/products/domain/use_cases/get_latest_products_use_case.dart';
import 'package:sufra_app/features/products/domain/use_cases/get_popular_products_use_case.dart';
import 'package:sufra_app/features/products/domain/use_cases/get_products_by_category_use_case.dart';
import 'package:sufra_app/features/products/domain/use_cases/get_products_use_case.dart';
import 'package:sufra_app/features/products/presentation/cubit/products/products_cubit.dart';
import 'package:sufra_app/features/profile/data/data_sources/profile_remote_data_source.dart';
import 'package:sufra_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:sufra_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:sufra_app/features/profile/domain/use_cases/get_profile_use_case.dart';
import 'package:sufra_app/features/profile/domain/use_cases/update_profile_use_case.dart';
import 'package:sufra_app/features/profile/presentation/cubit/profile/profile_cubit.dart';

import '../../features/authentication/data/data_sources/auth_remote_data_source.dart';
import '../../features/authentication/data/repositories/auth_repository_impl.dart';
import '../../features/authentication/domain/repositories/auth_repository.dart';
import '../../features/authentication/domain/use_cases/register_use_case.dart';
import '../../features/authentication/presentation/cubit/register/register_cubit.dart';
import 'package:sufra_app/features/products/domain/use_cases/search_products_use_case.dart';
import 'package:sufra_app/features/products/presentation/cubit/search/search_cubit.dart';

import 'package:sufra_app/features/favorites/data/data_sources/favorites_remote_data_source.dart';
import 'package:sufra_app/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:sufra_app/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:sufra_app/features/favorites/domain/use_cases/add_favorite_use_case.dart';
import 'package:sufra_app/features/favorites/domain/use_cases/get_favorites_use_case.dart';
import 'package:sufra_app/features/favorites/domain/use_cases/remove_favorite_use_case.dart';
import 'package:sufra_app/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:sufra_app/features/branches/data/data_sources/branches_remote_data_source.dart';
import 'package:sufra_app/features/branches/data/repositories/branches_repository_impl.dart';
import 'package:sufra_app/features/branches/domain/repositories/branches_repository.dart';
import 'package:sufra_app/features/branches/domain/use_cases/get_branches_use_case.dart';
import 'package:sufra_app/features/branches/presentation/cubit/branches/branches_cubit.dart';

import 'package:cloud_functions/cloud_functions.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Firebase
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  //Firestore
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
  getIt.registerLazySingleton<FirebaseFunctions>(
    () => FirebaseFunctions.instance,
  );
  // Data Source
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: getIt<FirebaseAuth>(),
      firestore: getIt<FirebaseFirestore>(),
    ),
  );

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt<AuthRemoteDataSource>()),
  );

  // Use Cases
  getIt.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepository>()),
  );

  // Cubits
  getIt.registerFactory<RegisterCubit>(
    () => RegisterCubit(getIt<RegisterUseCase>()),
  );

  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt<LoginUseCase>()));

  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(getIt<AuthRepository>()),
  );

  getIt.registerFactory<LogoutCubit>(() => LogoutCubit(getIt<LogoutUseCase>()));
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(
      firebaseAuth: getIt<FirebaseAuth>(),
      firestore: getIt<FirebaseFirestore>(),
    ),
  );

  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: getIt<ProfileRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<GetProfileUseCase>(
    () => GetProfileUseCase(getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(getIt<ProfileRepository>()),
  );
  getIt.registerFactory<ProfileCubit>(
    () => ProfileCubit(
      getProfileUseCase: getIt<GetProfileUseCase>(),
      updateProfileUseCase: getIt<UpdateProfileUseCase>(),
    ),
  );

  // Products

  getIt.registerLazySingleton<ProductsRemoteDataSource>(
    () => ProductsRemoteDataSourceImpl(firestore: getIt<FirebaseFirestore>()),
  );

  getIt.registerLazySingleton<ProductsRepository>(
    () => ProductsRepositoryImpl(
      remoteDataSource: getIt<ProductsRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(getIt<ProductsRepository>()),
  );

  getIt.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(getIt<ProductsRepository>()),
  );

  getIt.registerLazySingleton<GetPopularProductsUseCase>(
    () => GetPopularProductsUseCase(getIt<ProductsRepository>()),
  );
  getIt.registerLazySingleton<GetLatestProductsUseCase>(
    () => GetLatestProductsUseCase(getIt<ProductsRepository>()),
  );

  getIt.registerLazySingleton<GetProductsByCategoryUseCase>(
    () => GetProductsByCategoryUseCase(getIt<ProductsRepository>()),
  );

  getIt.registerFactory<ProductsCubit>(
    () => ProductsCubit(
      getCategoriesUseCase: getIt(),
      getPopularProductsUseCase: getIt(),
      getFeaturedProductsUseCase: getIt(),
      getProductsByCategoryUseCase: getIt(),
      getProductsUseCase: getIt(),
      getLatestProductsUseCase: getIt(),
    ),
  );
  getIt.registerLazySingleton<GetFeaturedProductsUseCase>(
    () => GetFeaturedProductsUseCase(getIt<ProductsRepository>()),
  );

  getIt.registerLazySingleton<OrdersRemoteDataSource>(
    () => OrdersRemoteDataSourceImpl(
      firestore: getIt<FirebaseFirestore>(),
      functions: getIt<FirebaseFunctions>(),
    ),
  );

  getIt.registerLazySingleton<OrdersRepository>(
    () =>
        OrdersRepositoryImpl(remoteDataSource: getIt<OrdersRemoteDataSource>()),
  );

  getIt.registerLazySingleton<CreateOrderUseCase>(
    () => CreateOrderUseCase(getIt<OrdersRepository>()),
  );

  getIt.registerLazySingleton<GetUserOrdersUseCase>(
    () => GetUserOrdersUseCase(getIt<OrdersRepository>()),
  );
  getIt.registerFactory<OrdersCubit>(
    () => OrdersCubit(
      createOrderUseCase: getIt<CreateOrderUseCase>(),
      getUserOrdersUseCase: getIt<GetUserOrdersUseCase>(),
    ),
  );

  getIt.registerLazySingleton<SearchProductsUseCase>(
    () => SearchProductsUseCase(getIt<ProductsRepository>()),
  );
  getIt.registerFactory<SearchCubit>(
    () => SearchCubit(searchProductsUseCase: getIt<SearchProductsUseCase>()),
  );

  getIt.registerLazySingleton<FavoritesRemoteDataSource>(
    () => FavoritesRemoteDataSourceImpl(firestore: getIt()),
  );

  getIt.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton<GetFavoritesUseCase>(
    () => GetFavoritesUseCase(getIt()),
  );

  getIt.registerLazySingleton<AddFavoriteUseCase>(
    () => AddFavoriteUseCase(getIt()),
  );

  getIt.registerLazySingleton<RemoveFavoriteUseCase>(
    () => RemoveFavoriteUseCase(getIt()),
  );

  getIt.registerFactory<FavoritesCubit>(
    () => FavoritesCubit(
      getFavoritesUseCase: getIt(),
      addFavoriteUseCase: getIt(),
      removeFavoriteUseCase: getIt(),
    ),
  );
  // Branches

  getIt.registerLazySingleton<BranchesRemoteDataSource>(
    () => BranchesRemoteDataSourceImpl(firestore: getIt<FirebaseFirestore>()),
  );

  getIt.registerLazySingleton<BranchesRepository>(
    () => BranchesRepositoryImpl(
      remoteDataSource: getIt<BranchesRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<GetBranchesUseCase>(
    () => GetBranchesUseCase(getIt<BranchesRepository>()),
  );

  getIt.registerFactory<BranchesCubit>(
    () => BranchesCubit(getBranchesUseCase: getIt<GetBranchesUseCase>()),
  );
}
