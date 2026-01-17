import 'package:flutter/material.dart';
import '../models/classification_result.dart';

class ResultCard extends StatelessWidget {
  final ClassificationResponse result;

  const ResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final topPrediction = result.topPrediction;
    
    // Debug logging
    print('🎯 ResultCard - Ensemble details:');
    print('   Is ensemble: ${result.isEnsemble}');
    print('   Models count: ${result.ensembleDetails?.modelsUsed.length ?? 0}');
    print('   Models: ${result.ensembleDetails?.modelsUsed}');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Top Prediction Card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF00D4AA).withOpacity(0.3),
                const Color(0xFF00A0E3).withOpacity(0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF00D4AA).withOpacity(0.5),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Text(
                topPrediction.emoji,
                style: const TextStyle(fontSize: 64),
              ),
              const SizedBox(height: 16),
              const Text(
                'Detected',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                topPrediction.displayLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF00D4AA),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  topPrediction.confidencePercent,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              // Ensemble Badge
              if (result.isEnsemble) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.purple.withOpacity(0.5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.groups, color: Colors.purple, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Ensemble: ${result.ensembleDetails!.modelsUsed.length} models',
                        style: const TextStyle(
                          color: Colors.purple,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        
        // Ensemble Details Card
        if (result.isEnsemble && result.ensembleDetails != null) ...[
          const SizedBox(height: 16),
          _buildEnsembleDetails(result.ensembleDetails!),
        ],
        
        const SizedBox(height: 24),

        // All Predictions
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1F3A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'All Predictions',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...result.predictions.map((prediction) {
                return _buildPredictionRow(prediction);
              }),
              const SizedBox(height: 16),
              Divider(color: Colors.white24),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Model: ${result.modelName}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  if (result.inferenceTime > 0)
                    Text(
                      'Time: ${result.inferenceTime.toStringAsFixed(1)}ms',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildEnsembleDetails(EnsembleDetails details) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.how_to_vote, color: Colors.purple, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Ensemble Voting Details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Voting Method
          _buildDetailRow(
            icon: Icons.ballot,
            label: 'Method',
            value: details.votingMethodDisplay,
          ),
          
          // Vote Count
          if (details.voteCount != null && details.totalModels != null)
            _buildDetailRow(
              icon: Icons.check_circle,
              label: 'Agreement',
              value: '${details.voteCount}/${details.totalModels} models',
            ),
          
          // Threshold
          _buildDetailRow(
            icon: Icons.filter_alt,
            label: 'Threshold',
            value: '${(details.threshold * 100).toInt()}%',
          ),
          
          // Model Predictions
          if (details.modelPredictions != null && details.modelPredictions!.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(color: Colors.white12),
            const SizedBox(height: 12),
            const Text(
              'Individual Model Votes:',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            ...details.modelPredictions!.map((pred) {
              return _buildModelVote(pred);
            }),
          ],
        ],
      ),
    );
  }
  
  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.purple.withOpacity(0.7)),
          const SizedBox(width: 8),
          Text(
            '$label:',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildModelVote(ModelPrediction pred) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.purple,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              pred.modelDisplayName,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ),
          Text(
            pred.prediction,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${(pred.confidence * 100).toStringAsFixed(0)}%',
            style: TextStyle(
              color: _getConfidenceColor(pred.confidence),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionRow(ClassificationResult prediction) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            prediction.emoji,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prediction.displayLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: prediction.confidence,
                    backgroundColor: Colors.white12,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getConfidenceColor(prediction.confidence),
                    ),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            prediction.confidencePercent,
            style: TextStyle(
              color: _getConfidenceColor(prediction.confidence),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.7) {
      return const Color(0xFF00D4AA);
    } else if (confidence >= 0.4) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
