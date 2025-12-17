import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/api_service.dart';
import '../models/classification_result.dart';
import '../widgets/result_card.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final ImagePicker _picker = ImagePicker();
  
  File? _selectedImage;
  ClassificationResponse? _result;
  bool _isLoading = false;
  String? _error;
  bool _isBackendHealthy = false;

  @override
  void initState() {
    super.initState();
    _checkBackendHealth();
  }

  Future<void> _checkBackendHealth() async {
    final isHealthy = await _apiService.checkHealth();
    setState(() {
      _isBackendHealthy = isHealthy;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _result = null;
          _error = null;
        });
        await _classifyImage();
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to pick image: $e';
      });
    }
  }

  Future<void> _classifyImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await _apiService.classifyImage(_selectedImage!);
      setState(() {
        _result = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      appBar: AppBar(
        title: const Text(
          'EcoSort - Trash Detector',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1A1F3A),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _isBackendHealthy ? Icons.circle : Icons.circle_outlined,
              color: _isBackendHealthy ? Colors.green : Colors.red,
              size: 12,
            ),
            onPressed: _checkBackendHealth,
            tooltip: _isBackendHealthy ? 'Backend Connected' : 'Backend Disconnected',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00D4AA), Color(0xFF00A0E3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 80,
                      height: 80,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'AI-Powered Waste Detection',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Upload or capture an image to classify trash',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.camera_alt,
                      label: 'Camera',
                      onPressed: () => _pickImage(ImageSource.camera),
                      color: const Color(0xFF00D4AA),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.photo_library,
                      label: 'Gallery',
                      onPressed: () => _pickImage(ImageSource.gallery),
                      color: const Color(0xFF00A0E3),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Backend Status
              if (!_isBackendHealthy)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Backend not connected. Please start the Django server.',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                      TextButton(
                        onPressed: _checkBackendHealth,
                        child: const Text('Retry', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                ),

              // Selected Image
              if (_selectedImage != null) ...[
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white24, width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                      height: 250,
                    ),
                  ),
                ),
              ],

              // Loading Indicator
              if (_isLoading) ...[
                const SizedBox(height: 32),
                const Center(
                  child: Column(
                    children: [
                      SpinKitRing(
                        color: Color(0xFF00D4AA),
                        size: 50.0,
                        lineWidth: 4.0,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Analyzing trash...',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Error Message
              if (_error != null) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Results
              if (_result != null && !_isLoading) ...[
                const SizedBox(height: 24),
                ResultCard(result: _result!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
