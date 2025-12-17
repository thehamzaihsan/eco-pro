import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/classification_result.dart';

class ApiService {
  // Change this to your backend URL
  // For local testing: 'http://10.0.2.2:8000' (Android emulator) or 'http://localhost:8000' (iOS simulator)
  // For production: 'https://your-backend.onrender.com'
  static const String baseUrl = 'http://127.0.0.1:8000';
  
  Future<ClassificationResponse> classifyImage(File imageFile) async {
    try {
      final uri = Uri.parse('$baseUrl/api/classify/');
      
      var request = http.MultipartRequest('POST', uri);
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ClassificationResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to classify image: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error classifying image: $e');
    }
  }

  Future<List<String>> getAvailableModels() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/models/'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return (jsonData['models'] as List).cast<String>();
      } else {
        throw Exception('Failed to load models');
      }
    } catch (e) {
      throw Exception('Error loading models: $e');
    }
  }

  Future<bool> checkHealth() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/models/'),
        headers: {'Connection': 'close'},
      ).timeout(const Duration(seconds: 5));
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
