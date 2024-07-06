import 'package:citiguide/Pages/homepage.dart';
import 'package:citiguide/Pages/loginpage.dart';
import 'package:citiguide/controllers/RegisterController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'backgroundui.dart';
// import 'profile_screen.dart';
// import 'signup.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final RegisterController registerController = Get.put(RegisterController());

  bool _obscurePassword = true; // Flag to toggle password visibility

  void _signupForm() {
    if (registerController.registerFormKey.currentState!.validate()) {
      // Implement signup logic here
      // print("Email: ${registerController.emailAddress.text}");
      // print("Password: ${registerController.password.text}");
      registerController.createUserWithEmailAndPassword();
      registerController.registerFormKey.currentState!.reset();
      registerController.emailAddress.text = "";
      registerController.password.text = "";
    }
  }

  void _navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  // @override
  // void dispose() {
  //   _nameController.dispose();
  //   _emailController.dispose();
  //   _passwordController.dispose();
  //   super.dispose();
  // }

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
                    // SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                    // const Text(
                    //   'Welcome Back!',
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 25,
                    //     color: Colors.white,
                    //   ),
                    // ),
                    // const SizedBox(height: 10),
                    // const Text(
                    //   'Discover your favorite places.',
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.w100,
                    //     fontSize: 15,
                    //     color: Colors.grey,
                    //   ),
                    // ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.35),
                    Form(
                      key: registerController.registerFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            ' Sign up',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: registerController.emailAddress,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Email",
                              prefixIcon:
                                  const Icon(Icons.person, color: Colors.blue),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
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
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: registerController.password,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Password",
                              prefixIcon:
                                  const Icon(Icons.lock, color: Colors.blue),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your password";
                              } else if (value.length < 6) {
                                return "Password must be at least 6 characters long";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            height: 45,
                            child: MaterialButton(
                              onPressed: _signupForm,
                              color: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text(
                                "Sign up",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an account?",
                                style: TextStyle(color: Colors.white),
                              ),
                              TextButton(
                                onPressed: _navigateToLogin,
                                child: const Text(
                                  "Sign in",
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
