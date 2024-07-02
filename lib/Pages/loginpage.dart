import 'package:citiguide/Pages/cityscreen.dart';
import 'package:citiguide/Pages/forgetpasspage.dart';

import 'package:citiguide/Pages/profile_page.dart';
import 'package:citiguide/controllers/LoginController.dart';
import 'package:flutter/material.dart';
import 'backgroundui.dart';

import 'signuppage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LoginController loginController = new LoginController();

  bool _obscurePassword = true;

  // @override
  // void dispose() {
  //   _emailController.dispose();
  //   _passwordController.dispose();
  //   super.dispose();
  // }

  void loginform() {
    if (loginController.LoginformKey[1].currentState!.validate()) {
      loginController.signInWithEmailAndPassword();
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => CityScreen(),
      //   ),
      // );
    }
  }

  void navigators() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignupPage(),
      ),
    );
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                    const Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Discover your favorite places.',
                      style: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                    Form(
                      key: loginController.LoginformKey[1],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            ' Login',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: loginController.emailAddress,
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
                            controller: loginController.password,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ForgetPassPage(),
                                      ));
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            height: 45,
                            child: MaterialButton(
                              onPressed: loginform,
                              color: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text(
                                "Login",
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
                                "Don't have an account?",
                                style: TextStyle(color: Colors.white),
                              ),
                              TextButton(
                                onPressed: navigators,
                                child: const Text(
                                  "Sign up",
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


// import 'package:cityguide/Pages/backgroundui.dart';

// import 'package:cityguide/Pages/profile_screen.dart';
// import 'package:cityguide/Pages/signup.dart';
// import 'package:cityguide/Pages/tourist_details.dart';
// import 'package:flutter/material.dart';

// import 'backgroundui.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController _emailController = TextEditingController();

//   final TextEditingController _passwordController = TextEditingController();

//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   bool _obscurePassword = true;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   loginform() {
//     if (_formKey.currentState!.validate()) {
//       print(_emailController.text);
//       print(_passwordController.text);
//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ProfileSettingsPage(),
//           ));
//     }
//   }

//   navigators() {
//     return Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => SignupPage(),
//         ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         const BackgroundUI(),
//         Scaffold(
//           backgroundColor: Colors.transparent,
//           body: Column(
//             // crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: EdgeInsets.fromLTRB(30, 100, 0, 20),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: const Text(
//                     'Welcome Back!',
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 30,
//                         color: Colors.black),
//                   ),
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.fromLTRB(30, 0, 0, 20),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     'Discover your favorite places.',
//                     style: TextStyle(
//                         fontWeight: FontWeight.w100,
//                         fontSize: 20,
//                         color: Colors.grey),
//                   ),
//                 ),
//               ),
//               Spacer(),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 30),
//                 // height: 570,
//                 // width: 350,
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           'Login',
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       TextFormField(
//                         controller: _emailController,
//                         decoration: InputDecoration(
//                           filled: true,
//                           fillColor: Colors.white,
//                           labelText: "Email",
//                           prefixIcon: Icon(Icons.person, color: Colors.blue),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return "Please enter your email";
//                           } else if (!RegExp(
//                                   r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
//                               .hasMatch(value)) {
//                             return "Invalid email format";
//                           }
//                           return null;
//                         },
//                       ),
//                       SizedBox(height: 7),
//                       TextFormField(
//                         controller: _passwordController,
//                         obscureText: _obscurePassword,
//                         decoration: InputDecoration(
//                           filled: true,
//                           fillColor: Colors.white,
//                           labelText: "Password",
//                           prefixIcon: Icon(Icons.lock, color: Colors.blue),
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               _obscurePassword
//                                   ? Icons.visibility
//                                   : Icons.visibility_off,
//                               color: Colors.blue,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 _obscurePassword = !_obscurePassword;
//                               });
//                             },
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return "Please enter your password";
//                           } else if (value.length < 6) {
//                             return "Password must be at least 6 characters long";
//                           }
//                           return null;
//                         },
//                       ),

//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           TextButton(
//                             onPressed: () {
//                               print('Forgotted Password!');
//                             },
//                             child: Text(
//                               'Forgot Password?',
//                               style: TextStyle(
//                                 color: Colors.white.withOpacity(0.8),
//                                 fontSize: 10.0,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       Container(
//                         width: double.infinity,
//                         height: 40,
//                         child: MaterialButton(
//                           onPressed: loginform,
//                           color: Colors.blue,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           child: Text(
//                             "Login",
//                             style: TextStyle(fontSize: 15, color: Colors.white),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),              
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             "Don't have an account?",
//                             style: TextStyle(color: Colors.white),
//                           ),
//                           TextButton(
//                             onPressed: navigators,
//                             child: const Text(
//                               "Sign up",
//                               // width: 50.0,
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color:
//                                       Colors.white), // Set text color to white
//                             ),
//                           )                     
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: MediaQuery.of(context).devicePixelRatio,
//               )
//             ],
//           ),
//         )
//       ],
//     );
//   }
// }
