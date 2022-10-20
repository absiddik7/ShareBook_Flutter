import 'package:flutter/material.dart';
import 'package:sharebook/blog/blogScreen.dart';
import 'package:sharebook/blog/friendListScreen.dart';
import 'package:sharebook/blog/profileScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen(
      {super.key,
      required this.authToken,
      required this.userId,
      required this.userName});
  final String? authToken;
  final int? userId;
  final String? userName;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text('ShareBook',
              style: TextStyle(
                  fontSize: 26,
                  color: Colors.green,
                  fontWeight: FontWeight.bold)),
          //shadowColor: Colors.transparent,
          elevation: 3,
          bottom: TabBar(
            padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            //labelStyle: const TextStyle(fontSize: 18),
            labelPadding: const EdgeInsets.symmetric(horizontal: 30),
            indicator: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(20)),
            tabs: const [
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.people)),
              Tab(icon: Icon(Icons.person)),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(children: [
                BlogScreen(
                  authToken: authToken,
                  id: userId,
                  
                ),
                FriendListScreen(
                  authToken: authToken,
                ),
                ProfileScreen(
                  authToken: authToken,
                  id: userId,
                  name: userName,
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
