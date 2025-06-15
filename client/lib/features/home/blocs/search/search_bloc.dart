import 'package:amazon_clone/features/home/services/search_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchServices _searchServices;

  SearchBloc(this._searchServices) : super(SearchInitial()) {
    on<FetchSearchedProducts>(_onFetchSearchedProducts);
  }

  Future<void> _onFetchSearchedProducts(
    FetchSearchedProducts event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());
    try {
      final products = await _searchServices.fetchSearchedProduct(
        searchQuery: event.query,
        token: event.token,
      );
      emit(SearchLoaded(products: products));
    } catch (e) {
      emit(SearchError(message: e.toString()));
    }
  }
}
