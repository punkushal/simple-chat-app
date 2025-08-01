import 'package:flutter/material.dart';
import 'package:simple_chat_app/screens/auth/login_screen.dart';
import 'package:simple_chat_app/services/auth_service.dart';
import 'package:simple_chat_app/widgets/custom_button.dart';
import 'package:simple_chat_app/widgets/custom_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final authService = AuthService();

  bool passwordVissibility = true;
  bool confirmPasswordVissibility = true;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  void togglePasswordVissibility() {
    setState(() {
      passwordVissibility = !passwordVissibility;
    });
  }

  void toggleConfirmPasswordVissibility() {
    setState(() {
      confirmPasswordVissibility = !confirmPasswordVissibility;
    });
  }

  Future<void> onSigningup() async {
    if (formKey.currentState!.validate()) {
      await authService.signUpWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
        nameController.text.trim(),
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
                Text('Create your account', style: TextStyle(fontSize: 26)),
                CustomTextField(
                  controller: nameController,
                  hintText: "Name",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This field required";
                    } else if (value.length < 4) {
                      return "Name character must have greater than 4 ";
                    }
                    return null;
                  },
                ),
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
                CustomTextField(
                  controller: confirmPasswordController,
                  hintText: "Confirm Password",
                  obscureText: confirmPasswordVissibility,
                  keyboardType: TextInputType.visiblePassword,
                  suffixIcon: IconButton(
                    onPressed: () {
                      toggleConfirmPasswordVissibility();
                    },
                    icon: confirmPasswordVissibility
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This field required";
                    } else if (value != passwordController.text.trim()) {
                      return "Password don't match ";
                    }
                    return null;
                  },
                ),

                CustomButton(
                  buttonLabelText: 'Sign up',
                  isLoading: false,
                  onPressed: () {
                    onSigningup();
                  },
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 4,
                  children: [
                    Text('Already have an account?'),
                    GestureDetector(
                      onTap: () {
                        //Navigation to login screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (ctx) => LoginScreen()),
                        );
                      },
                      child: Text(
                        'Login',
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
