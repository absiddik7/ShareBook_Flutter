import 'package:flutter/material.dart';
import 'package:sharebook/blog/api/blog_api.dart';

class FriendListScreen extends StatefulWidget {
  const FriendListScreen({super.key, required this.authToken});
  final String? authToken;

  @override
  State<FriendListScreen> createState() => _FriendListScreenState();
}

class _FriendListScreenState extends State<FriendListScreen> {
  var users;
  bool _loading = true;

  @override
  void initState() {
    _loading = true;
    super.initState();
    getUsers();
    setState(() {
      getUsers();
    });
  }

  getUsers() async {
    BlogApiData dataClass = BlogApiData();
    await dataClass.getAllUsers(widget.authToken!);
    users = dataClass.users;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: users.length,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Card(
                            color: Colors.green[50],
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children:  [
                                      // Profile image
                                      const CircleAvatar(
                                        backgroundImage: AssetImage(
                                          'assets/images/logo.png',
                                        ),
                                        radius: 18,
                                      ),
                                      const SizedBox(width: 6),
                                      // Author name
                                      Text(
                                        users[index].name,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
    );
  }
}
