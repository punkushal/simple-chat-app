import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_chat_app/providers/auth_provider.dart';
import 'package:simple_chat_app/screens/auth/signup_screen.dart';
import 'package:simple_chat_app/screens/home_screen.dart';
import 'package:simple_chat_app/services/auth_service.dart';
import 'package:simple_chat_app/widgets/custom_button.dart';
import 'package:simple_chat_app/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();

  final formKey = GlobalKey<FormState>();
  bool passwordVissibility = true;

  @override
  void dispose() {
    super.dispose();

    emailController.dispose();
    passwordController.dispose();
  }

  void togglePasswordVissibility() {
    setState(() {
      passwordVissibility = !passwordVissibility;
    });
  }

  void _handleLogin(AuthProvider authProvider) async {
    if (formKey.currentState!.validate()) {
      final success = await authProvider.signIn(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (success && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (ctx) => HomeScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 14,
              children: [
                Text('Welcome again', style: TextStyle(fontSize: 26)),
                CustomTextField(
                  controller: emailController,
                  hintText: "Email",
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This field required";
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: passwordVissibility,
                  keyboardType: TextInputType.visiblePassword,
                  suffixIcon: IconButton(
                    onPressed: () {
                      togglePasswordVissibility();
                    },
                    icon: passwordVissibility
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This field required";
                    } else if (value.length < 8) {
                      return "Password should  have greater than 8 characters ";
                    }
                    return null;
                  },
                ),

                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return CustomButton(
                      buttonLabelText: 'Login',
                      onPressed: () => _handleLogin(authProvider),
                      isLoading: authProvider.isLoading,
                    );
                  },
                ),

                const SizedBox(height: 16),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    if (authProvider.errorMessage.isNotEmpty) {
                      return Text(
                        authProvider.errorMessage,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 4,
                  children: [
                    Text("Don't have an account?"),
                    GestureDetector(
                      onTap: () {
                        //Navigation to signup screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (ctx) => SignupScreen()),
                        );
                      },
                      child: Text(
                        'Signup',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
