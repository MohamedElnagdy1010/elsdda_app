import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sufra_app/features/products/domain/use_cases/search_products_use_case.dart';

import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchProductsUseCase searchProductsUseCase;

  Timer? _debounce;
  int _searchVersion = 0;

  SearchCubit({required this.searchProductsUseCase})
    : super(const SearchInitial());

  void search(String value) {
    final query = value.trim();

    _debounce?.cancel();

    // يبطل أي نتيجة قديمة لبحث سابق.
    _searchVersion++;

    if (query.isEmpty) {
      emit(const SearchInitial());
      return;
    }

    // اختيارياً: لا نبحث إلا بعد حرفين.
    if (query.length < 2) {
      emit(const SearchWaiting());
      return;
    }

    emit(const SearchWaiting());

    final currentVersion = _searchVersion;

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query: query, version: currentVersion);
    });
  }

  Future<void> _performSearch({
    required String query,
    required int version,
  }) async {
    emit(const SearchLoading());

    try {
      final products = await searchProductsUseCase(query);

      // المستخدم كتب حاجة جديدة أثناء انتظار Firestore.
      // بالتالي نتجاهل النتيجة القديمة.
      if (version != _searchVersion || isClosed) {
        return;
      }

      if (products.isEmpty) {
        emit(SearchEmpty(query));
        return;
      }

      emit(SearchLoaded(products: products, query: query));
    } catch (e) {
      if (version != _searchVersion || isClosed) {
        return;
      }

      emit(const SearchFailure('حدث خطأ أثناء البحث، حاول مرة أخرى'));
    }
  }

  void clearSearch() {
    _debounce?.cancel();
    _searchVersion++;

    emit(const SearchInitial());
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
