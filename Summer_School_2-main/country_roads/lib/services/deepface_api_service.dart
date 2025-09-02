import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class DeepfaceApiService {
  static final _apiUrl = dotenv.env['API_URL'];

  static void uploadUserPicture(String userId, String imageData) {
    http.post(
      Uri.parse('$_apiUrl/upload_pic'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'user_id': userId,
        'image_data': imageData
      }), 
    );
  }

  static Future<String> findUserByFace(String imageData) async {
    final response = await http.post(
      Uri.parse('$_apiUrl/find'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'image_data': imageData
      }), 
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['result'] != "ok") {
        throw Exception('Failed to find user by face');
      }

      return jsonDecode(response.body)['user_id'];
    } 
    else {
      throw Exception('Failed to find user by face');
    }
  }

  static Future<int> countFaces(String imageData) async {
    final response = await http.post(
      Uri.parse('$_apiUrl/count_faces'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'image_data': imageData
      }), 
    );

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        return data['count'];
      }
      catch (e) {
        throw Exception('Failed to count faces in image');
      }
    } 
    else {
      throw Exception('Failed to count faces in image');
    }
  }
}