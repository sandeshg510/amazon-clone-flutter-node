import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/user.dart';
import '../blocs/auth_bloc/auth_bloc.dart';

extension AuthContext on BuildContext {
  User get currentUser {
    final state = read<AuthBloc>().state;
    if (state is Authenticated) return state.user;
    throw Exception('User not authenticated');
  }
}
