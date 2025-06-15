import 'package:amazon_clone/constants/bloc/user_bloc/user_bloc.dart';
import 'package:amazon_clone/core/common/widgets/bottom_bar.dart';
import 'package:amazon_clone/features/admin/screens/admin_screen.dart';
import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/global_variables.dart';
import '../../../../router.dart';
import '../../../admin/blocs/admin_bloc.dart';
import '../../data/auth_repository.dart';
import '../blocs/auth_bloc/auth_bloc.dart';
import 'welcome_screen.dart';

class MyApp extends StatelessWidget {
  final AuthRepository authRepository = AuthRepository();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AuthBloc(authRepository: authRepository)..add(AppStarted()),
        ),
        BlocProvider(
          create: (context) => UserBloc(),
        ),
      ],
      child: MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: 'Amazon',
            scaffoldBackgroundColor: GlobalVariables.backgroundColor,
            colorScheme: const ColorScheme.light(
                primary: GlobalVariables.secondaryColor,
                secondary: GlobalVariables.secondaryColor),
            appBarTheme: const AppBarTheme(
                elevation: 0, iconTheme: IconThemeData(color: Colors.black)),
          ),
          debugShowCheckedModeBanner: false,
          onGenerateRoute: (settings) => generateRoute(settings, context),
          // In your widget tree
          home: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              // Handle errors
              if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }

              // Handle successful authentication HERE
              if (state is Authenticated) {
                print("User authenticated with type: ${state.user.type}");
                context.read<UserBloc>().add(InitializeUser(user: state.user));

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (state.user.type.toLowerCase() == 'admin') {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (_) => BlocProvider(
                                create: (context) => AdminBloc(
                                    adminServices: AdminServices(),
                                    authToken: state.user.token),
                                child: AdminScreen(token: state.user.token),
                              )),
                      (route) => false,
                    );
                  } else {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const BottomBar()),
                      (route) => false,
                    );
                  }
                });
              }
            },
            builder: (context, state) {
              print("Current auth state: $state");

              if (state is AuthLoading) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              // Return empty container when authenticated to avoid WelcomeScreen flash
              if (state is Authenticated) {
                return const Scaffold(
                    body: Center(child: CircularProgressIndicator()));
              }

              // Only show WelcomeScreen for unauthenticated states
              return const WelcomeScreen();
            },
          )),
    );
  }
}
