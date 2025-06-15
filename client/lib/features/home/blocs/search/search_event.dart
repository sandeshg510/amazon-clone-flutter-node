import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class FetchSearchedProducts extends SearchEvent {
  final String query;
  final String token;

  const FetchSearchedProducts({required this.query, required this.token});

  @override
  List<Object> get props => [query, token];
}
