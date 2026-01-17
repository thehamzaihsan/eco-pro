class ClassificationResult {
  final String label;
  final double confidence;

  ClassificationResult({
    required this.label,
    required this.confidence,
  });

  factory ClassificationResult.fromJson(Map<String, dynamic> json) {
    final className = json['class_name'] ?? json['label'] ?? 'unknown';
    final conf = json['confidence'] ?? 0;
    
    return ClassificationResult(
      label: className.toString(),
      confidence: (conf as num).toDouble(),
    );
  }

  String get emoji {
    switch (label.toLowerCase()) {
      case 'paper':
        return '��';
      case 'cardboard':
        return '📦';
      case 'plastic':
        return '🥤';
      case 'vegetation':
        return '🌿';
      case 'biological':
        return '🍂';
      case 'metal':
        return '🔩';
      case 'clothes':
        return '👕';
      case 'glass':
        return '🍾';
      case 'trash':
        return '🗑️';
      case 'shoes':
        return '👟';
      case 'battery':
        return '🔋';
      default:
        return '❓';
    }
  }

  String get displayLabel {
    if (label.isEmpty) return 'Unknown';
    return label[0].toUpperCase() + label.substring(1);
  }

  String get confidencePercent {
    return '${(confidence * 100).toStringAsFixed(1)}%';
  }
}

class EnsembleDetails {
  final String votingMethod;
  final List<String> modelsUsed;
  final Map<String, dynamic>? votes;
  final int? voteCount;
  final int? totalModels;
  final double threshold;
  final List<ModelPrediction>? modelPredictions;

  EnsembleDetails({
    required this.votingMethod,
    required this.modelsUsed,
    this.votes,
    this.voteCount,
    this.totalModels,
    required this.threshold,
    this.modelPredictions,
  });

  factory EnsembleDetails.fromJson(Map<String, dynamic> json) {
    final modelPredsList = json['model_predictions'] as List?;
    
    return EnsembleDetails(
      votingMethod: json['voting_method']?.toString() ?? 'unknown',
      modelsUsed: (json['models_used'] as List?)?.map((e) => e.toString()).toList() ?? [],
      votes: json['votes'] as Map<String, dynamic>?,
      voteCount: json['vote_count'] as int?,
      totalModels: json['total_models'] as int?,
      threshold: (json['threshold'] ?? 0.3).toDouble(),
      modelPredictions: modelPredsList?.map((p) => ModelPrediction.fromJson(p)).toList(),
    );
  }

  bool get isEnsemble => modelsUsed.isNotEmpty;
  
  String get votingMethodDisplay {
    if (votingMethod.contains('majority')) return 'Majority Voting';
    if (votingMethod.contains('weighted')) return 'Weighted Voting';
    return votingMethod;
  }
}

class ModelPrediction {
  final String model;
  final String prediction;
  final double confidence;

  ModelPrediction({
    required this.model,
    required this.prediction,
    required this.confidence,
  });

  factory ModelPrediction.fromJson(Map<String, dynamic> json) {
    return ModelPrediction(
      model: json['model']?.toString() ?? 'unknown',
      prediction: json['prediction']?.toString() ?? 'unknown',
      confidence: ((json['confidence'] ?? 0) as num).toDouble(),
    );
  }
  
  String get modelDisplayName {
    if (model.contains('yolov11n')) return 'YOLOv11 Nano';
    if (model.contains('yolov11m')) return 'YOLOv11 Medium';
    if (model.contains('yolov11l')) return 'YOLOv11 Large';
    if (model.contains('yolov8')) return 'YOLOv8';
    return model;
  }
}

class ClassificationResponse {
  final List<ClassificationResult> predictions;
  final String modelName;
  final double inferenceTime;
  final EnsembleDetails? ensembleDetails;

  ClassificationResponse({
    required this.predictions,
    required this.modelName,
    required this.inferenceTime,
    this.ensembleDetails,
  });

  factory ClassificationResponse.fromJson(Map<String, dynamic> json) {
    try {
      final predictionsList = json['predictions'] as List?;
      final model = json['model'] ?? json['model_name'] ?? 'Unknown Model';
      final inferenceMs = json['inference_time_ms'] ?? json['inference_time'] ?? 0;
      
      // Check if this is an ensemble response
      EnsembleDetails? ensemble;
      if (json['ensemble_details'] != null) {
        ensemble = EnsembleDetails.fromJson(json['ensemble_details']);
      }
      
      return ClassificationResponse(
        predictions: predictionsList != null
            ? predictionsList
                .map((p) => ClassificationResult.fromJson(p as Map<String, dynamic>))
                .toList()
            : [],
        modelName: model.toString(),
        inferenceTime: (inferenceMs as num).toDouble(),
        ensembleDetails: ensemble,
      );
    } catch (e) {
      print('Error parsing classification response: $e');
      print('JSON received: $json');
      rethrow;
    }
  }

  ClassificationResult get topPrediction {
    if (predictions.isEmpty) {
      return ClassificationResult(label: 'unknown', confidence: 0.0);
    }
    return predictions.first;
  }
  
  bool get isEnsemble => ensembleDetails != null && ensembleDetails!.isEnsemble;
}
