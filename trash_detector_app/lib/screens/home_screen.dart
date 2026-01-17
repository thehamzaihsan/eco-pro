import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
import 'package:image_picker/image_picker.dart';
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
  
  XFile? _selectedImage;
  ClassificationResponse? _result;
  bool _isLoading = false;
  String? _error;
  bool _isBackendHealthy = false;
  
  // Model selection
  bool _useEnsemble = true;
  String _selectedModel = 'yolov11n-12class';
  double _confidenceThreshold = 0.3;
  String _votingMethod = 'majority';
  
  // Available models (fetched from backend)
  List<Map<String, dynamic>> _availableModels = [];

  @override
  void initState() {
    super.initState();
    _checkBackendHealth();
    _loadAvailableModels();
  }

  Future<void> _checkBackendHealth() async {
    final isHealthy = await _apiService.checkHealth();
    setState(() {
      _isBackendHealthy = isHealthy;
    });
  }
  
  Future<void> _loadAvailableModels() async {
    try {
      final response = await _apiService.getAvailableModels();
      setState(() {
        _availableModels = response;
      });
    } catch (e) {
      print('Failed to load models: $e');
    }
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
          _selectedImage = image;
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
      ClassificationResponse result;
      
      if (_useEnsemble) {
        result = await _apiService.classifyImageEnsemble(
          _selectedImage!,
          threshold: _confidenceThreshold,
          method: _votingMethod,
        );
      } else {
        result = await _apiService.classifyImageSingle(
          _selectedImage!,
          model: _selectedModel,
        );
      }
      
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

  void _showModelSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1F3A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.settings, color: Color(0xFF00D4AA)),
                    const SizedBox(width: 12),
                    const Text(
                      'Classification Settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Ensemble Toggle
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _useEnsemble 
                          ? Colors.purple.withOpacity(0.5)
                          : Colors.white.withOpacity(0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.groups,
                        color: _useEnsemble ? Colors.purple : Colors.white70,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ensemble Mode',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Use multiple models for better accuracy',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _useEnsemble,
                        activeColor: Colors.purple,
                        onChanged: (value) {
                          setModalState(() {
                            _useEnsemble = value;
                          });
                          setState(() {
                            _useEnsemble = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Single Model Selection
                if (!_useEnsemble) ...[
                  const Text(
                    'Select Model',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedModel,
                      isExpanded: true,
                      dropdownColor: const Color(0xFF1A1F3A),
                      style: const TextStyle(color: Colors.white),
                      underline: const SizedBox(),
                      items: _availableModels.map((model) {
                        return DropdownMenuItem<String>(
                          value: model['key'],
                          child: Row(
                            children: [
                              const Icon(Icons.model_training, 
                                  color: Color(0xFF00D4AA), size: 20),
                              const SizedBox(width: 8),
                              Text(model['name'] ?? model['key']),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setModalState(() {
                            _selectedModel = value;
                          });
                          setState(() {
                            _selectedModel = value;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Ensemble Settings
                if (_useEnsemble) ...[
                  const Text(
                    'Confidence Threshold',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: _confidenceThreshold,
                          min: 0.1,
                          max: 0.9,
                          divisions: 8,
                          activeColor: Colors.purple,
                          inactiveColor: Colors.white.withOpacity(0.2),
                          label: '${(_confidenceThreshold * 100).toInt()}%',
                          onChanged: (value) {
                            setModalState(() {
                              _confidenceThreshold = value;
                            });
                            setState(() {
                              _confidenceThreshold = value;
                            });
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${(_confidenceThreshold * 100).toInt()}%',
                          style: const TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Voting Method
                  const Text(
                    'Voting Method',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildVotingMethodButton(
                          'majority',
                          'Majority',
                          Icons.how_to_vote,
                          setModalState,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildVotingMethodButton(
                          'weighted',
                          'Weighted',
                          Icons.balance,
                          setModalState,
                        ),
                      ),
                    ],
                  ),
                ],
                
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (_selectedImage != null) {
                        _classifyImage();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00D4AA),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Apply Settings',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildVotingMethodButton(
    String value,
    String label,
    IconData icon,
    StateSetter setModalState,
  ) {
    final isSelected = _votingMethod == value;
    return InkWell(
      onTap: () {
        setModalState(() {
          _votingMethod = value;
        });
        setState(() {
          _votingMethod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected 
              ? Colors.purple.withOpacity(0.2)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected 
                ? Colors.purple
                : Colors.white.withOpacity(0.1),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.purple : Colors.white70,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.purple : Colors.white70,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
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
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showModelSettings,
            tooltip: 'Model Settings',
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
              const SizedBox(height: 16),
              
              // Current Settings Display
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    Icon(
                      _useEnsemble ? Icons.groups : Icons.model_training,
                      color: _useEnsemble ? Colors.purple : const Color(0xFF00D4AA),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _useEnsemble 
                            ? 'Ensemble Mode (${(_confidenceThreshold * 100).toInt()}% threshold)'
                            : 'Single Model: $_selectedModel',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 18),
                      color: Colors.white70,
                      onPressed: _showModelSettings,
                      tooltip: 'Change Settings',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  if (!kIsWeb)
                    Expanded(
                      child: _buildActionButton(
                        icon: Icons.camera_alt,
                        label: 'Camera',
                        onPressed: () => _pickImage(ImageSource.camera),
                        color: const Color(0xFF00D4AA),
                      ),
                    ),
                  if (!kIsWeb) const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.photo_library,
                      label: kIsWeb ? 'Choose Image' : 'Gallery',
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
                    child: FutureBuilder<Uint8List>(
                      future: _selectedImage!.readAsBytes(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Image.memory(
                            snapshot.data!,
                            fit: BoxFit.cover,
                            height: 250,
                          );
                        } else if (snapshot.hasError) {
                          return Container(
                            height: 250,
                            color: Colors.grey[800],
                            child: const Center(
                              child: Icon(Icons.error, color: Colors.red, size: 48),
                            ),
                          );
                        } else {
                          return Container(
                            height: 250,
                            color: Colors.grey[800],
                            child: const Center(
                              child: CircularProgressIndicator(color: Color(0xFF00D4AA)),
                            ),
                          );
                        }
                      },
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
