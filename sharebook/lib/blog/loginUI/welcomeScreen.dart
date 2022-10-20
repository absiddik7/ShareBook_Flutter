import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  final String text;
  const WelcomeScreen({super.key, required this.text});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WelcomePage(title: 'Welcome'),
    );
  }
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key, required this.title});
  final String title;
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
// Do the design here
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidht = MediaQuery.of(context).size.width;
    final text = ModalRoute.of(context)!.settings.arguments as Text;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 50,
              ),
              const Text(
                "Welcome",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              const Text(
                'text.toString()',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              const SizedBox(
                height: 50,
              ),
              // Add image

              const CircleAvatar(
                backgroundImage: AssetImage(
                  'assets/images/logo.png',
                ),
                radius: 100,
              ),

              // show given input text
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                height: deviceHeight * 0.06,
                width: deviceWidht * 0.8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: ElevatedButton(
                    onPressed: () {},
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
              const SizedBox(
                height: 20,
              ),
              Container(
                height: deviceHeight * 0.06,
                width: deviceWidht * 0.8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[300],
                        elevation: 12.0,
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        )),
                    child: const Text('SIGNUP'),
                  ),
                ),
              ),

              /*Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
              */
            ],
          ),
        ),
      ),
    );
  }
}
