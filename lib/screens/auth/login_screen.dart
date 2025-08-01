import 'package:flutter/material.dart';
import 'package:simple_chat_app/screens/auth/signup_screen.dart';
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

  Future<void> onLogin() async {
    if (formKey.currentState!.validate()) {
      await authService.loginWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      return;
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

                CustomButton(
                  buttonLabelText: 'Login',
                  isLoading: false,
                  onPressed: () {
                    onLogin();
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
