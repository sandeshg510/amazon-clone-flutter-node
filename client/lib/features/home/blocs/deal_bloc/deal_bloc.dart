import 'dart:async';

import 'package:amazon_clone/models/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repository/home_repository.dart';
import 'deal_event.dart';
import 'deal_state.dart';

class DealBloc extends Bloc<DealEvent, DealState> {
  final HomeRepository repository;

  DealBloc(this.repository) : super(const DealState()) {
    on<FetchDealOfTheDay>(_onFetchDeal);
    on<FetchBestDealForYou>(_onFetchBestDealForYou);
  }

  Future<void> _onFetchDeal(
      FetchDealOfTheDay event, Emitter<DealState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final product = await repository.getDealOfTheDay();
      emit(state.copyWith(dealOfTheDay: product, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  Future<void> _onFetchBestDealForYou(
      FetchBestDealForYou event, Emitter<DealState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final List<Product> products = await repository.getBestDeals();
      emit(state.copyWith(bestDeals: products, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}
