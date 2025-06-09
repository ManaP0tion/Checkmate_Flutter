import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pp/themes/strings.dart';

Future<Map<String, dynamic>?> fetchUserInfo() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('access_token');
  if(token == null){
    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StartPage()));
    return null;
  }

  final response = await http.get(
      Uri.parse('http://${ipHome}/api/users/me/'),
      headers: {
        'Authorization' : 'Bearer $token',
        'Content-Type' : 'application/json'
      }
  );

  if(response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return null; // 오류처리
  }

}