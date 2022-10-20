// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:sharebook/blog/api/blog_api.dart';
import 'package:sharebook/blog/loginUI/signup.dart';
import 'package:sharebook/home.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(title: 'Login'),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});
  final String title;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String email = '';

  static const failedSnackBar = SnackBar(
    content: Text('Post Failed!'),
    backgroundColor: Colors.red,
  );

// Do the design here
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidht = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              const Text(
                "ShareBook",
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 35),
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                "Login",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              const SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      // email input field
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      width: deviceWidht * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          hintText: 'Your Email',
                          border: InputBorder.none,
                        ),
                        autofillHints: const [AutofillHints.email],
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email';
                          } else if (EmailValidator.validate(value) != true) {
                            return 'Invalid Email';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      // password input field
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      width: deviceWidht * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.lock),
                          hintText: 'Password',
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                // Login button
                height: deviceHeight * 0.06,
                width: deviceWidht * 0.8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        BlogApiData blogApiClass = BlogApiData();
                        
                       
                        try {
                          await blogApiClass
                              .login(_emailController.text,
                                  _passwordController.text)
                              .then((value) {
                            
                            if (value.status == 'success') {
                              _emailController.clear();
                              _passwordController.clear();
                              var token = value.authorisation!.token;
                              var id = value.user!.id;

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen(
                                            authToken: token,
                                            userId: id,
                                            userName: 'name',
                                          )));
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(failedSnackBar);
                            }
                          });
                        } catch (e) {
                           ScaffoldMessenger.of(context)
                                  .showSnackBar(failedSnackBar);
                          //
                        }
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(failedSnackBar);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 12.0,
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        )),
                    child: const Text('LOGIN'),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an Account?"),
                  GestureDetector(
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupScreen()));
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
