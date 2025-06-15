import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/core/common/widgets/basics.dart';
import 'package:amazon_clone/core/common/widgets/custom_text_field.dart';
import 'package:amazon_clone/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:amazon_clone/utils/assets_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/widgets/bottom_bar.dart';
import '../../../admin/screens/admin_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const String routeName = '/sign-in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with CommonWidgets {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          alignment: Alignment.bottomCenter,
          ImagePaths.instance.brandNameLogoPath,
          height: 36,
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }

          // Handle successful signin
          if (state is Authenticated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(
                  context,
                  state.user.type == 'admin'
                      ? AdminScreen.routeName
                      : BottomBar.routeName);
            });
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(height: 0.5, color: Colors.grey),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    verticalSpace(height: 10),
                    const Text('Sign in',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700)),
                    verticalSpace(height: 22),
                    const Text('Enter email address',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                    verticalSpace(height: 4),
                    CustomTextField(
                        controller: emailController, hintText: 'abc@mail.com'),
                    verticalSpace(height: 22),
                    const Text('Enter password',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                    verticalSpace(height: 4),
                    CustomTextField(
                        controller: passwordController,
                        hintText: '34sgg#at5DFwj'),
                    verticalSpace(height: 28),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: state is SignInLoading
                              ? null
                              : () {
                                  context.read<AuthBloc>().add(
                                        SignIn(
                                          email: emailController.text.trim(),
                                          password:
                                              passwordController.text.trim(),
                                        ),
                                      );
                                },
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: Colors.yellow,
                              elevation: 0),
                          child: state is SignInLoading
                              ? const CircularProgressIndicator()
                              : const Text('Continue',
                                  style: TextStyle(
                                      fontSize: 16,
                                      letterSpacing: 0.7,
                                      color: Colors.black)),
                        );
                      },
                    ),
                    verticalSpace(height: 18),
                    RichText(
                        text: TextSpan(
                            style: const TextStyle(height: 1.6),
                            children: [
                          const TextSpan(
                              text: 'By continuing, you agree to Amazon\'s ',
                              style: TextStyle(color: Colors.black)),
                          TextSpan(
                              text: 'Conditions of Use',
                              style: TextStyle(
                                  color: Colors.blue.shade700,
                                  decoration: TextDecoration.underline)),
                          const TextSpan(
                              text: ' and ',
                              style: TextStyle(color: Colors.black)),
                          TextSpan(
                              text: 'Privacy Notice',
                              style: TextStyle(
                                  color: Colors.blue.shade700,
                                  decoration: TextDecoration.underline)),
                        ])),
                    verticalSpace(height: 40),
                  ],
                ),
              ),
              Container(height: 2, color: Colors.blueGrey.shade100),
              verticalSpace(height: 38),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Conditions of Use',
                      style:
                          TextStyle(fontSize: 16, color: Colors.blue.shade700)),
                  Text('Privacy Notice',
                      style:
                          TextStyle(fontSize: 16, color: Colors.blue.shade700)),
                  Text('Help',
                      style:
                          TextStyle(fontSize: 16, color: Colors.blue.shade700)),
                ],
              ),
              verticalSpace(height: 20),
              const Text('1996-2025, Amazon.com, Inc. or its affiliates ',
                  style: TextStyle(color: Colors.black87, fontSize: 12))
            ],
          ),
        ),
      ),
    );
  }
}
