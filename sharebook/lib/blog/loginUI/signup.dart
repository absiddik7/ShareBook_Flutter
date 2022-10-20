import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'package:email_validator/email_validator.dart';
import 'package:sharebook/blog/api/blog_api.dart';
import 'package:sharebook/blog/loginUI/login.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignupPage(title: 'Sign Up'),
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key, required this.title});
  final String title;
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _reEntryPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String email = '';

  void successDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Success"),
      content: const Text("Your sign-up is successful"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static const successSnackBar = SnackBar(
      content: Text('Post Successful'),
      backgroundColor: Colors.green,
    );

    static const failedSnackBar = SnackBar(
      content: Text('Post Failed!'),
      backgroundColor: Colors.red,
    );




  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidht = MediaQuery.of(context).size.width;
    String pass = '';
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
                "Sign Up",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              const SizedBox(height: 50),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      // name input field
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      width: deviceWidht * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          hintText: 'Enter name',
                          border: InputBorder.none,
                        ),
                        autofillHints: const [AutofillHints.email],
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter name';
                          }
                          return null;
                        },
                      ),
                    ),
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
                          icon: Icon(Icons.mail),
                          hintText: 'Enter Email',
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
                      // pass input field
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
                          hintText: 'Enter Password',
                          border: InputBorder.none,
                        ),
                        obscureText: true,
                        onChanged: (text) {
                          pass = text;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      // confirm pass input field
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      width: deviceWidht * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: TextFormField(
                        controller: _reEntryPasswordController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.lock),
                          hintText: 'Re-enter Password',
                          border: InputBorder.none,
                        ),
                        obscureText: true,
                        onChanged: (text) {},
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          } else if (value != pass) {
                            return 'Password mismatch';
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
                    onPressed: () async{
                      if (_formKey.currentState!.validate()) {
                        BlogApiData blogApiClass = BlogApiData();
                        var name = _nameController.text;
                        var email = _emailController.text;
                        var password =  _passwordController.text;
                        
                        await blogApiClass
                            .registration(
                                name,email,password )
                            .then((value) {
                          if (value.status == 'success') {
                            ScaffoldMessenger.of(context)
                            .showSnackBar(failedSnackBar);
                            _emailController.clear();
                            _passwordController.clear();
                  
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen(
                                          
                                        )));
                          } else {
                            ScaffoldMessenger.of(context)
                            .showSnackBar(failedSnackBar);
                          }
                        });
                      } else {
                        // do something
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 12.0,
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        )),
                    child: const Text('SIGNUP'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
