import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../models/user.dart';
import '../../../data/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<SignIn>(_onSignIn);
    on<SignUp>(_onSignUp);
    on<Logout>(_onLogout);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      print("App started, checking authentication...");
      final token = await _authRepository.getToken();
      print("Token retrieved: ${token != null ? 'Found' : 'Not found'}");

      if (token != null) {
        print("Validating token...");
        final isValid = await _authRepository.validateToken(token);
        print("Token validation result: $isValid");

        if (isValid) {
          print("Token is valid, getting user data...");
          final user = await _authRepository.getUserData(token);
          print("User data retrieved. Type: ${user.type}");
          emit(Authenticated(user));
          return;
        }
      }
      print("No valid authentication, emitting Unauthenticated");
      emit(Unauthenticated());
    } catch (e) {
      print("Error during app start: $e");
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignIn(SignIn event, Emitter<AuthState> emit) async {
    emit(SignInLoading());
    try {
      final user = await _authRepository.signIn(event.email, event.password);
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignUp(SignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signUp(
        event.name,
        event.email,
        event.password,
      );
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogout(Logout event, Emitter<AuthState> emit) async {
    await _authRepository.logout();
    emit(Unauthenticated());
  }
}
