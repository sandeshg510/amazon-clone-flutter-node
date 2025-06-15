import 'package:amazon_clone/constants/bloc/user_bloc/user_state.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_event.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<SetUserFromJson>(_onSetUserFromJson);
    on<UpdateUserCart>(_onUpdateUserCart);
    on<SetUserFromModel>(_onSetUserFromModel);
    on<InitializeUser>((event, emit) {
      emit(UserLoaded(event.user));
    });
  }

  void _onSetUserFromJson(SetUserFromJson event, Emitter<UserState> emit) {
    try {
      final user = User.fromJson(event.userJson as String);
      emit(UserLoaded(user));
    } catch (e) {
      emit(const UserError('Failed to load user data'));
    }
  }

  void _onSetUserFromModel(SetUserFromModel event, Emitter<UserState> emit) {
    emit(UserLoaded(event.user));
  }

  void _onUpdateUserCart(UpdateUserCart event, Emitter<UserState> emit) {
    if (state is UserLoaded) {
      final currentUser = (state as UserLoaded).user;
      final updatedUser = currentUser.copyWith(cart: event.newCart);
      emit(UserLoaded(updatedUser));
    }
  }
}
