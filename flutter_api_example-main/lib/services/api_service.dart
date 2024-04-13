import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_api_example/models/comment.dart';
import 'package:flutter_api_example/models/post.dart';

class ApiService {
  // Setup the Dio object with the baseUrl
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://ikara-development.appspot.com',
    headers: {
      "authorization": 'Bearer ${""}',
      'content-Type' : 'application/x-www-form-urlencoded',
      // options.contentType ='application/x-www-form-urlencoded';
    },
  ),
  );

  // Default Constructor. Since we have no parameters needed to create an ApiService object, the constructor is empty
  ApiService();


  Future<List<Post>> getPosts() async {
    // Try to run this block of code. If any exceptions are thrown, they are caught in the catch block
    try {
      // Wait for dio to get recieve a response from the server
      Map parameter = {
        "userId": "7B30D808-BE36-492B-A002-1F9BCB1755E6-893-0000005832A0B5F1",
        "platform": "IOS",
        "language": "vi",
        "properties": {
          "cursor":
          "ClMKEQoLdmlld0NvdW50ZXISAggEEjpqCXN-aWthcmE0bXItCxIQRGFpbHlWaWV3Q291bnRlciIXNDk4NiMxNjk1ODIzMjAwMDAwI3ZpIzIMGAAgAQ:::AAAAAQ=="
        },
      };

      String param64 =
          'eyJ1c2VySWQiOiIyQ0JERTZFRS00M0JBLTQ0NEItOUZENy1EREM3ODZBRDhGMzEtMzc1NTctMDAwMDEwMEREODlDNDU0MiIsInBsYXRmb3JtIjoiSU9TIiwibGFuZ3VhZ2UiOiJlbi55b2thcmEiLCJwYWNrYWdlTmFtZSI6ImNvbS5kZXYueW9rYXJhIiwicHJvcGVydGllcyI6eyJjdXJzb3IiOm51bGx9fQ==-915376685910417';
      Map<String, dynamic> params = {'parameters': param64};

      String path = 'https://ikara-development.appspot.com/v32.TopSongs';
      final Response response = await _dio.post(path,data: params);
      // Check if the response status code is OK
      print("datatataatat ${response.data}");
      if (response.statusCode == 200) {
        // Convert the response data to a List of JSON objects then convert each JSON object to a Post object and
        // return the List of Post objects
        return Post.listFromJson(jsonDecode(response.data)['songs122']);

      }
      // If response status code is not OK, throw an exception
      else {
        throw Exception(
            'GET call returned with status code: ${response.statusCode}');
      }
    }
    // Catch any exception as the variable e
    catch (e) {
      print("Error encountered: $e");
      // Return an empty list if an exception is caught
      return [];
    }
  }

  // An asynchronous function that returns a List of Comment objects or throws an exception
  Future<List<Comment>> getPostComments({required int postId}) async {
    // Try to run this block of code. If any exceptions are thrown, they are caught in the catch block
    try {
      // Convert the response data to a List of JSON objects then convert each JSON object to a Comment object and
      // return the List of Comment objects
      final Response response = await _dio.get(
        '/comments',
        // Pass in the id of the post you want the comments of
        queryParameters: {'postId': postId},
      );
      // Check if the response status code is OK
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((element) => Comment.fromJson(element))
            .toList();
      }
      // If response status code is not OK, throw an exception
      else {
        throw Exception(
            'GET call returned with status code: ${response.statusCode}');
      }
    }
    // Catch any exception as the variable e
    catch (e) {
      print("Error encountered: $e");
      // Return an empty list if an exception is caught
      return [];
    }
  }
}
