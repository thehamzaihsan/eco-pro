class ClassificationResult {
  final String label;
  final double confidence;

  ClassificationResult({
    required this.label,
    required this.confidence,
  });

  factory ClassificationResult.fromJson(Map<String, dynamic> json) {
    return ClassificationResult(
      label: json['label'] as String,
      confidence: (json['confidence'] as num).toDouble(),
    );
  }

  String get emoji {
    switch (label.toLowerCase()) {
      case 'paper':
        return '📄';
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
    return label[0].toUpperCase() + label.substring(1);
  }

  String get confidencePercent {
    return '${(confidence * 100).toStringAsFixed(1)}%';
  }
}

class ClassificationResponse {
  final List<ClassificationResult> predictions;
  final String modelName;
  final double inferenceTime;

  ClassificationResponse({
    required this.predictions,
    required this.modelName,
    required this.inferenceTime,
  });

  factory ClassificationResponse.fromJson(Map<String, dynamic> json) {
    return ClassificationResponse(
      predictions: (json['predictions'] as List)
          .map((p) => ClassificationResult.fromJson(p))
          .toList(),
      modelName: json['model_name'] as String,
      inferenceTime: (json['inference_time_ms'] as num).toDouble(),
    );
  }

  ClassificationResult get topPrediction => predictions.first;
}
