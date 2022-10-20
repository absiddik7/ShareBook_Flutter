import 'package:flutter/material.dart';
import 'package:sharebook/blog/api/blog_api.dart';
import 'package:sharebook/blog/blogScreen.dart';

class BlogPostScreen extends StatefulWidget {
  const BlogPostScreen(
      {super.key,
      required this.authToken,
      required this.id,
      this.postTitle,
      this.postBody,
      this.postId});
  final String? authToken;
  final int? id;
  final int? postId;
  final String? postTitle;
  final String? postBody;

  @override
  State createState() => BlogPostScreenState();
}

class BlogPostScreenState extends State<BlogPostScreen> {
  @override
  Widget build(BuildContext context) {
    //final authorController = TextEditingController();
    final titleController = TextEditingController();
    final blogBodyController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    BlogApiData apiData = BlogApiData();

    setState(() {
      titleController.text = widget.postTitle!;
      blogBodyController.text = widget.postBody!;
    });

    const successSnackBar = SnackBar(
      content: Text('Post Successful'),
      backgroundColor: Colors.green,
    );

    const failedSnackBar = SnackBar(
      content: Text('Post Failed!'),
      backgroundColor: Colors.red,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Write Post'),
      ),
      //backgroundColor: Colors.purple[200],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: formKey,
              child: Container(
                margin: const EdgeInsets.only(top: 20, left: 15, right: 15),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // post title
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter Title',
                          labelStyle: TextStyle(fontSize: 20),
                          hintText: 'Post title'),
                    ),
                    const SizedBox(height: 20),
                    // Post body
                    TextField(
                      controller: blogBodyController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Write blog',
                          labelStyle: TextStyle(fontSize: 20),
                          hintText: 'Wrtie your blog here...'),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),
            // Save Button
            SizedBox(
              height: 50,
              width: 300,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      // save data into api
                      //var author = authorController.text;
                      var title = titleController.text;
                      var blog = blogBodyController.text;

                      if (widget.postTitle == '') {
                        // Insert Post
                        var status = await apiData.postBlog(widget.authToken!,
                            widget.id!.toString(), title, blog);
                        if (status == 200) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(successSnackBar);
                          Navigator.pop(context); // back to Blog Screen

                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(failedSnackBar);
                        }
                      } else {
                        // Update Post

                        var updatedTitle = titleController.text;
                        var updatedBody = blogBodyController.text;

                        var status = await apiData.updateBlog(
                            widget.authToken!,
                            widget.postId!,
                            widget.id!.toString(),
                            updatedTitle,
                            updatedBody);
                        if (status == 200) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(successSnackBar);
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(failedSnackBar);
                        }
                      }
                    } else {
                      // do something()
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 12.0,
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      )),
                  child: const Text('SAVE'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
