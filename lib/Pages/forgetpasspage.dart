import 'package:CityNavigator/Pages/loginpage.dart';
import 'package:CityNavigator/Theme/color.dart';
import 'package:CityNavigator/controllers/LoginController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'backgroundui.dart';

class ForgetPassPage extends StatefulWidget {
  const ForgetPassPage({super.key});

  @override
  State<ForgetPassPage> createState() => _ForgetPassPageState();
}

class _ForgetPassPageState extends State<ForgetPassPage> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _resetPassword() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      try {
        await LoginController.sendPasswordResetEmail(_emailController.text);
        Get.to(() => const LoginPage());
        // Show success message or navigate to appropriate screen
        Get.snackbar(
          'Password Reset',
          'Password reset email sent to ${_emailController.text}',
          backgroundColor: const Color.fromARGB(160, 81, 160, 136),
          barBlur: 3.0,
          colorText: Colors.white,
          borderRadius: 5,
          borderWidth: 50,
          dismissDirection: DismissDirection.horizontal,
        );
      } catch (e) {
        // Handle errors
        Get.snackbar(
          'Password Reset',
          'Failed to send password reset email: $e',
          backgroundColor: const Color.fromARGB(160, 81, 160, 136),
          barBlur: 3.0,
          colorText: Colors.white,
          borderRadius: 5,
          borderWidth: 50,
          dismissDirection: DismissDirection.horizontal,
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundUI(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.35),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Forget Password',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              filled: true,
                              focusColor: ColorTheme.primaryColor,
                              hoverColor: ColorTheme.primaryColor,
                              fillColor: Colors.white,
                              hintText: "Email",
                              prefixIcon: Icon(Icons.person,
                                  color: ColorTheme.primaryColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your email";
                              } else if (!RegExp(
                                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value)) {
                                return "Invalid email format";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: _resetPassword,
                              style: ElevatedButton.styleFrom(
                                elevation: 5,
                                backgroundColor: ColorTheme.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: const Text(
                                "Reset Password",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Get.offAll(() => const LoginPage());
                                },
                                child: const Text(
                                  "Log in with another account.",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
