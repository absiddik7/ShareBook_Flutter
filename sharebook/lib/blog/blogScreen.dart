import 'package:flutter/material.dart';
import 'package:sharebook/blog/api/blog_api.dart';
import 'package:sharebook/blog/blogPost.dart';
import 'package:sharebook/model/blog_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:favorite_button/favorite_button.dart';

enum Menu { itemUpdate, itemDelete }

enum LogoutMenu { itemLogout }

class BlogScreen extends StatefulWidget {
  const BlogScreen({
    super.key,
    required this.authToken,
    required this.id,
  });
  final String? authToken;
  final int? id;

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  List<BlogModel> blogs = [];
  bool isLiked = false;
  bool _loading = true;

  @override
  void initState() {
    _loading = true;
    super.initState();
    setState(() {
      getBlogs();
    });
  }

  getBlogs() async {
    BlogApiData dataClass = BlogApiData();
    await dataClass.getAllBlogs(widget.authToken!);
    blogs = dataClass.blogs;
    setState(() {
      _loading = false;
      blogs = dataClass.blogs;
    });
  }

  static const warningSnackBar = SnackBar(
    content: Text("Other's post can't be Modified!"),
    backgroundColor: Colors.deepOrange,
  );

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
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: blogs.length,
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
                                      Text(blogs[index].authorName!,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),

                                      const Spacer(),
                                      // update/delte popup menu
                                      PopupMenuButton<Menu>(
                                          onSelected: (Menu item) async {
                                            if (widget.id ==
                                                blogs[index].author) {
                                              if (item.name == 'itemUpdate') {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            BlogPostScreen(
                                                              authToken: widget
                                                                  .authToken,
                                                              id: widget.id,
                                                              postId:
                                                                  blogs[index]
                                                                      .id!,
                                                              postTitle:
                                                                  blogs[index]
                                                                      .title!,
                                                              postBody:
                                                                  blogs[index]
                                                                      .body,
                                                            ))).then(
                                                    (value) => setState(() {
                                                          getBlogs();
                                                        }));
                                              } else {
                                                //delete blog
                                                await dataClass
                                                    .deleteBlog(
                                                        blogs[index].id!,
                                                        widget.authToken!)
                                                    .whenComplete(() {
                                                  setState(() {
                                                    getBlogs();
                                                  });
                                                });
                                              }
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                      warningSnackBar);
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
                                      blogs[index].title!,
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
                                      blogs[index].body!,
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
                                                getBlogs();
                                              });
                                              dataClass.incrementLike(
                                                  blogs[index].id!,
                                                  widget.authToken!);
                                              setState(() {
                                                getBlogs();
                                              });

                                              //_refreshList();
                                            } else {
                                              dataClass.decrementLike(
                                                  blogs[index].id!,
                                                  widget.authToken!);
                                              setState(() {
                                                getBlogs();
                                              });
                                            }
                                          },
                                        ),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                        Text(blogs[index].likes.toString()),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                            icon: const Icon(Icons.share),
                                            //tooltip: 'Increase volume by 10',
                                            onPressed: () async {
                                              await Share.share(
                                                  blogs[index].body!,
                                                  subject: blogs[index].title!);
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
                getBlogs();
              }));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
