// user_event.dart
part of 'user_bloc.dart';

@immutable
sealed class UserEvent extends Equatable {
  const UserEvent();
}

class SetUserFromJson extends UserEvent {
  final Map<String, dynamic> userJson;
  const SetUserFromJson(this.userJson);

  @override
  List<Object> get props => [userJson];
}

class SetUserFromModel extends UserEvent {
  final User user;
  const SetUserFromModel(this.user);

  @override
  List<Object> get props => [user];
}

class UpdateUserCart extends UserEvent {
  final List<dynamic> newCart;
  const UpdateUserCart(this.newCart);

  @override
  List<Object> get props => [newCart];
}

class InitializeUser extends UserEvent {
  final User user;
  const InitializeUser({required this.user});

  @override
  List<Object?> get props => [user];
}
