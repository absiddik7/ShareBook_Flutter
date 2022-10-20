import 'package:flutter/material.dart';
import 'package:sharebook/blog/api/blog_api.dart';
import 'package:sharebook/blog/blogPost.dart';
import 'package:sharebook/model/blog_model.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:share_plus/share_plus.dart';

enum Menu { itemUpdate, itemDelete }

enum LogoutMenu { itemLogout }

class ProfileScreen extends StatefulWidget {
  const ProfileScreen(
      {super.key,
      required this.authToken,
      required this.id,
      required this.name});
  final String? authToken;
  final int? id;
  final String? name;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<BlogModel> userBlogs = [];
  bool isLiked = false;
  bool _loading = true;

  @override
  void initState() {
    _loading = true;
    super.initState();
    setState(() {
      getUserBlogs();
    });
  }

  getUserBlogs() async {
    BlogApiData dataClass = BlogApiData();
    await dataClass.getUserBlogs(widget.authToken!);
    userBlogs = dataClass.userBlogs;
    setState(() {
      _loading = false;
      userBlogs = dataClass.userBlogs;
    });
  }

  @override
  Widget build(BuildContext context) {
    BlogApiData dataClass = BlogApiData();
    return Scaffold(
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: Column(
                        children: [
                          const CircleAvatar(
                            backgroundImage: AssetImage(
                              'assets/images/logo.png',
                            ),
                            radius: 45,
                          ),
                          const SizedBox(width: 6),
                          //Author name
                          Text(userBlogs[0].authorName!,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      )),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: userBlogs.length,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Card(
                            color: Colors.blueGrey[50],
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    children: [
                                      // Profile image
                                      const CircleAvatar(
                                        backgroundImage: AssetImage(
                                          'assets/images/logo.png',
                                        ),
                                        radius: 25,
                                      ),
                                      const SizedBox(width: 6),
                                      //Author name
                                      Text(userBlogs[index].authorName!,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),

                                      const Spacer(),
                                      // update/delte popup menu
                                      PopupMenuButton<Menu>(
                                          onSelected: (Menu item) async {
                                            if (item.name == 'itemUpdate') {
                                            } else {
                                              //delete blog
                                              await dataClass
                                                  .deleteBlog(
                                                      userBlogs[index].id!,
                                                      widget.authToken!)
                                                  .whenComplete(() {
                                                setState(() {
                                                  getUserBlogs();
                                                });
                                              });
                                            }
                                          },
                                          itemBuilder: (BuildContext context) =>
                                              <PopupMenuEntry<Menu>>[
                                                const PopupMenuItem<Menu>(
                                                  value: Menu.itemUpdate,
                                                  child: Text('Update'),
                                                ),
                                                const PopupMenuItem<Menu>(
                                                  value: Menu.itemDelete,
                                                  child: Text('Delete'),
                                                ),
                                              ]),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  thickness: 0.5,
                                  color: Colors.grey,
                                ),
                                // Title
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    //margin: const EdgeInsets.only(top: 5),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    child: Text(
                                      userBlogs[index].title!,
                                      style: const TextStyle(
                                          color: Colors.deepOrange,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                //Blog body
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      userBlogs[index].body!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 3),
                                const Divider(
                                  thickness: 0.5,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 3),
                                //Like/Dislike/share
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      children: [
                                        FavoriteButton(
                                          iconSize: 45,
                                          valueChanged: (isFavorite) async {
                                            if (isFavorite == true) {
                                              setState(() {
                                                getUserBlogs();
                                              });
                                              dataClass.incrementLike(
                                                  userBlogs[index].id!,
                                                  widget.authToken!);
                                              setState(() {
                                                getUserBlogs();
                                              });

                                              //_refreshList();
                                            } else {
                                              dataClass.decrementLike(
                                                  userBlogs[index].id!,
                                                  widget.authToken!);
                                              setState(() {
                                                getUserBlogs();
                                              });
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                        Text(userBlogs[index].likes.toString()),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                            icon: const Icon(Icons.share),
                                            //tooltip: 'Increase volume by 10',
                                            onPressed: () async {
                                              await Share.share(
                                                  userBlogs[index].body!,
                                                  subject:
                                                      userBlogs[index].title!);
                                            }),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BlogPostScreen(
                        authToken: widget.authToken,
                        id: widget.id,
                        postTitle: '',
                        postBody: '',
                      ))).then((value) => setState(() {
                getUserBlogs();
              }));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
