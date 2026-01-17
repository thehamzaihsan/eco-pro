import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import '../models/classification_result.dart';

class ApiService {
  // Backend URL - Using network IP for physical device access
  static const String baseUrl = 'http://192.168.1.100:8000';
  
  Future<ClassificationResponse> classifyImage(XFile imageFile) async {
    // Default behavior - can be overridden by settings
    return classifyImageEnsemble(imageFile, threshold: 0.3);
  }
  
  Future<ClassificationResponse> classifyImageEnsemble(
    XFile imageFile, {
    double threshold = 0.3,
    String method = 'majority',
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/api/classify/ensemble/');
      
      var request = http.MultipartRequest('POST', uri);
      
      final bytes = await imageFile.readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          bytes,
          filename: imageFile.name,
        ),
      );
      
      request.fields['threshold'] = threshold.toString();
      request.fields['method'] = method;

      print('🎯 Ensemble request: threshold=$threshold, method=$method');
      
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        try {
          final jsonData = json.decode(response.body);
          print('📊 Ensemble response received:');
          print('  Models: ${jsonData['ensemble_details']?['models_used']}');
          print('  Total models: ${(jsonData['ensemble_details']?['models_used'] as List?)?.length}');
          return ClassificationResponse.fromJson(jsonData);
        } catch (e) {
          print('❌ Error parsing JSON: $e');
          throw Exception('Failed to parse ensemble response: $e');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}\n${response.body}');
      }
    } catch (e) {
      print('❌ Error in ensemble classification: $e');
      throw Exception('Error classifying image with ensemble: $e');
    }
  }
  
  Future<ClassificationResponse> classifyImageSingle(
    XFile imageFile, {
    String model = 'yolov11n-12class',
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/api/classify/');
      
      var request = http.MultipartRequest('POST', uri);
      
      final bytes = await imageFile.readAsBytes();
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          bytes,
          filename: imageFile.name,
        ),
      );
      
      request.fields['model'] = model;

      print('📡 Single model request: model=$model');
      
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        try {
          final jsonData = json.decode(response.body);
          return ClassificationResponse.fromJson(jsonData);
        } catch (e) {
          print('❌ Error parsing JSON: $e');
          throw Exception('Failed to parse response: $e');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}\n${response.body}');
      }
    } catch (e) {
      print('❌ Error in single model classification: $e');
      throw Exception('Error classifying image: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAvailableModels() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/models/'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final models = jsonData['models'] as List;
        return models.map((m) => m as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load models');
      }
    } catch (e) {
      print('Error loading models: $e');
      // Return default models if API fails
      return [
        {'key': 'yolov11n-12class', 'name': 'YOLOv11n (12 Classes)', 'classes': 12},
        {'key': 'yolov11m-3class', 'name': 'YOLOv11m (3 Classes)', 'classes': 3},
        {'key': 'yolov8n-3class', 'name': 'YOLOv8n (3 Classes)', 'classes': 3},
        {'key': 'yolov8n-detect', 'name': 'YOLOv8n Detection', 'classes': 3},
      ];
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
      print('Health check failed: $e');
      return false;
    }
  }
}
