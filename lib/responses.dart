import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';


class LoginResponse {
  final String user;
  final String token;

  LoginResponse({this.user, this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: json["user"],
      token: json["token"],
    );
  }
}

Future<LoginResponse> createLoginResponse({Map body}) async {
  final response = await http.post(
      'https://safe-park-backend.herokuapp.com/auth/login',
      headers: {"Content-Type": "application/json"},
      body: json.encode(body));

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return LoginResponse.fromJson(json.decode(response.body));
  } else {
    if (json.decode(response.body)['user'] == false) {
      throw Exception('Username or password is incorrect');
    }
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

Future<http.Response> createRegisterResponse({Map body}) async {
  final response = await http.post(
      'https://safe-park-backend.herokuapp.com/auth/register',
      headers: {"Content-Type": "application/json"},
      body: json.encode(body));

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return response;
  } else if (json.decode(response.body) == "An error occurred: UserExistsError: A user with the given username is already registered") {
    throw Exception("Username used by another user!");
  } else {
    throw Exception('Failed to load post');
  }
}

Future<http.Response> createAlertResponse({Map body}) async {
  // Get token
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = await prefs.getString('jwt');

  // Set external player ID instead of the given onesignal ID
  http.Response response = await http.post('https://safe-park-backend.herokuapp.com/user/alert',
      headers: {HttpHeaders.authorizationHeader: "Bearer " + token, "Content-Type": "application/json"},
      body: json.encode(body));

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return response;
  } else {
    throw Exception('Plate number not found in the database :(');
  }
}