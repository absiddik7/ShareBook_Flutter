import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';
import 'package:sharebook/model/blog_model.dart';
import 'package:sharebook/model/login_model.dart';
import 'package:sharebook/model/registration_model.dart';
import 'package:sharebook/model/userModel.dart';

class BlogApiData {
  List<BlogModel> blogs = [];
  List<BlogModel> userBlogs = [];
  List<UserModel> users = [];
  final ip = 'http://192.168.1.12:5000';

  // Registration
  Future<RegistrationModel> registration(
      String name, String email, String password) async {
    String url = '$ip/api/register';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
      },
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      print('Registration successfully');
      return RegistrationModel.fromJson(jsonDecode(response.body));
    } else {
      print('Registration failed');
      return RegistrationModel.fromJson(jsonDecode(response.body));
    }
  }

  // Login
  Future<LoginModel> login(String email, String password) async {
    var response;
    try {
      String url = '$ip/api/login';
      response = await http.post(
        Uri.parse(url),
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
        },
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        print('Login successfully ');
        return LoginModel.fromJson(jsonDecode(response.body));
      } else {
        print('Login failed');
        print(response.body);
        return LoginModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      return LoginModel.fromJson(jsonDecode(response.body));
      // TODO: handle exception, for example by showing an alert to the user
    }
  }

  // Post(Insert) Data
  Future<int> postBlog(
      String token, String author, String title, String blog) async {
    String postUrl = '$ip/api/blogs';
    final response = await http.post(Uri.parse(postUrl), headers: {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'bearer $token',
    }, body: {
      'author': author,
      'title': title,
      'body': blog,
    });

    if (response.statusCode == 200) {
      print('post successful');
      return 200;
    } else {
      print('post failed');
      return 0;
    }
  }

  // Get all blog
  Future<void> getAllBlogs(String token) async {
    String blogUrl = '$ip/api/blogs';
    var response = await http.get(
      Uri.parse(blogUrl),
      headers: {
        HttpHeaders.authorizationHeader: 'bearer $token',
      },
    );
    var jsonData = jsonDecode(response.body);
    jsonData.forEach((element) {
      BlogModel blogModel = BlogModel(
          id: element['id'],
          author: element['author'],
          authorName: element['author_name'],
          title: element['title'],
          body: element['body'],
          likes: element['likes']);
      blogs.add(blogModel);
    });
  }

  // Get Users Blogs
  Future<void> getUserBlogs(String token) async {
    String blogUrl = 'http://192.168.1.12:5000/api/userblog';
    var response = await http.get(
      Uri.parse(blogUrl),
      headers: {
        HttpHeaders.authorizationHeader: 'bearer $token',
      },
    );
    var jsonData = jsonDecode(response.body);
    jsonData['data'].forEach((element) {
      BlogModel blogModel = BlogModel(
          id: element['id'],
          author: element['author'],
          authorName: element['author_name'],
          title: element['title'],
          body: element['body'],
          likes: element['likes']);
      userBlogs.add(blogModel);
    });
  }

  // Get all users
  Future<void> getAllUsers(String token) async {
    String usersUrl = '$ip/api/users';
    var response = await http.get(
      Uri.parse(usersUrl),
      headers: {
        HttpHeaders.authorizationHeader: 'bearer $token',
      },
    );
    var jsonData = jsonDecode(response.body);
    jsonData['users'].forEach((element) {
      UserModel userModel = UserModel(
        id: element['id'],
        //author: element['author'],
        name: element['name'],
        email: element['email'],
      );
      users.add(userModel);
    });
  }

  // Delete blog
  Future<http.Response> deleteBlog(int id, String token) async {
    final http.Response response = await http.delete(
      Uri.parse('$ip/api/blogs/$id'),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'bearer $token',
      },
    );

    return response;
  }

// update blog
  Future<int> updateBlog(
      String token, int id, String author, String title, String blog) async {
    String postUrl = '$ip/api/blogs/$id';
    final response = await http.put(Uri.parse(postUrl), headers: {
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'bearer $token',
    }, body: {
      'author': author,
      'title': title,
      'body': blog,
    });

    if (response.statusCode == 200) {
      print('post successful');
      return 200;
    } else {
      print('post failed');
      return 0;
    }
  }

  // update like
  Future<http.Response> updateLike(
      int id, int author, String title, String blog) {
    return http.put(
      Uri.parse('$ip/api/blogs/$id'),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
      },
      body: {
        'id': id,
        'author': author,
        'title': title,
        'body': blog,
      },
    );
  }

// like increment
  Future<http.Response> incrementLike(int id, String token) {
    return http.put(
      Uri.parse('$ip/api/like/increment/$id'), // done
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'bearer $token',
      },
    );
  }

// like decrement
  Future<http.Response> decrementLike(int id, String token) {
    return http.put(
      Uri.parse('$ip/api/like/decrement/$id'), // done
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'bearer $token',
      },
    );
  }

// dislike increment
  Future<http.Response> incrementDislike(int id, String token) {
    return http.put(
      Uri.parse('$ip/api/dislike/increment/$id'), // done
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'bearer $token',
      },
    );
  }

// dislike decrement
  Future<http.Response> decrementDislike(int id, String token) {
    return http.put(
      Uri.parse('$ip/api/dislike/decrement/$id'), // done
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'bearer $token',
      },
    );
  }
}
