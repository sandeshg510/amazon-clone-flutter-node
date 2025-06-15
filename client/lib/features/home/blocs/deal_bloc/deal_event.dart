import 'package:equatable/equatable.dart';

abstract class DealEvent extends Equatable {
  const DealEvent();

  @override
  List<Object?> get props => [];
}

class FetchDealOfTheDay extends DealEvent {
  final String token;

  const FetchDealOfTheDay(this.token);

  @override
  List<Object?> get props => [token];
}

class FetchBestDealForYou extends DealEvent {
  final String token;

  const FetchBestDealForYou(this.token);

  @override
  List<Object?> get props => [token];
}
