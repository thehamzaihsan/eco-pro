"""
Ensemble Voting System for Multiple YOLO Models
Combines predictions from multiple models using majority voting
with confidence threshold filtering
"""

from collections import Counter
from typing import List, Dict, Any
from django.conf import settings
from .yolo_model import get_yolo_model


class EnsembleVoting:
    def __init__(self, confidence_threshold=0.3):
        """
        Initialize ensemble voting system
        
        Args:
            confidence_threshold: Minimum confidence to consider a prediction (default: 0.3)
        """
        self.confidence_threshold = confidence_threshold
        self.models_to_use = []
        
        # Model weights - give more weight to 12-class model
        self.model_weights = {
            'yolov11n-12class': 2.0,  # Double weight for 12-class model
            'yolov11m-3class': 1.0,
            'yolov8n-3class': 1.0,
            'yolov8n-detect': 1.0,
        }
        
        # Load ALL available models for ensemble
        for key, config in settings.YOLO_MODELS.items():
            self.models_to_use.append(key)
        
        print(f"🎭 Ensemble initialized with {len(self.models_to_use)} models: {self.models_to_use}")
        print(f"⚖️ Model weights: {self.model_weights}")
    
    def classify_with_ensemble(self, image_path: str) -> Dict[str, Any]:
        """
        Classify image using ensemble of ALL models with WEIGHTED majority voting
        Models have different weights (12-class model gets 2x weight)
        
        Args:
            image_path: Path to the image file
            
        Returns:
            Dict containing:
                - final_prediction: The class chosen by weighted vote
                - confidence: Average confidence from voting models
                - votes: Vote counts for each class
                - model_predictions: Individual predictions from each model
                - models_used: List of models used
        """
        all_predictions = []
        model_results = []
        
        print(f"🔍 Running WEIGHTED ensemble with {len(self.models_to_use)} models...")
        
        # Get predictions from ALL models
        for model_key in self.models_to_use:
            try:
                print(f"  📊 Querying model: {model_key} (weight: {self.model_weights.get(model_key, 1.0)})")
                model = get_yolo_model(model_key)
                predictions = model.predict(image_path)
                
                if predictions:
                    # Filter by confidence threshold
                    filtered_predictions = [
                        pred for pred in predictions 
                        if pred['confidence'] >= self.confidence_threshold
                    ]
                    
                    if filtered_predictions:
                        # Take top prediction from this model
                        top_pred = filtered_predictions[0]
                        
                        print(f"    ✅ {model_key}: {top_pred['class_name']} ({top_pred['confidence']:.2f})")
                        
                        all_predictions.append({
                            'class_name': top_pred['class_name'],
                            'confidence': top_pred['confidence'],
                            'model': model_key,
                            'weight': self.model_weights.get(model_key, 1.0)
                        })
                        
                        model_results.append({
                            'model': model_key,
                            'prediction': top_pred['class_name'],
                            'confidence': top_pred['confidence'],
                            'weight': self.model_weights.get(model_key, 1.0),
                            'all_predictions': filtered_predictions[:5]  # Top 5
                        })
                    else:
                        print(f"    ⚠️ {model_key}: No predictions above threshold ({self.confidence_threshold})")
                else:
                    print(f"    ⚠️ {model_key}: No predictions returned")
            except Exception as e:
                print(f"    ❌ Error with model {model_key}: {e}")
                continue
        
        print(f"📊 Total predictions collected: {len(all_predictions)}")
        
        # If no valid predictions, return empty result
        if not all_predictions:
            return {
                'final_prediction': None,
                'confidence': 0.0,
                'votes': {},
                'model_predictions': model_results,
                'models_used': self.models_to_use,
                'voting_method': 'weighted_majority_voting',
                'threshold': self.confidence_threshold,
                'total_models_attempted': len(self.models_to_use),
                'successful_predictions': 0
            }
        
        # Perform WEIGHTED majority voting
        class_weighted_votes = {}
        for pred in all_predictions:
            class_name = pred['class_name']
            weight = pred['weight']
            
            if class_name not in class_weighted_votes:
                class_weighted_votes[class_name] = 0
            class_weighted_votes[class_name] += weight
        
        # Find class with highest weighted vote
        final_class = max(class_weighted_votes, key=class_weighted_votes.get)
        weighted_vote_count = class_weighted_votes[final_class]
        total_weight = sum(class_weighted_votes.values())
        
        print(f"🗳️ Weighted voting results: {class_weighted_votes}")
        print(f"🏆 Winner: {final_class} with {weighted_vote_count:.1f}/{total_weight:.1f} weighted votes")
        
        # Calculate average confidence for the winning class
        winning_confidences = [
            pred['confidence'] 
            for pred in all_predictions 
            if pred['class_name'] == final_class
        ]
        avg_confidence = sum(winning_confidences) / len(winning_confidences)
        
        # Prepare detailed vote information
        votes_detail = {
            class_name: {
                'weighted_count': weighted_count,
                'percentage': (weighted_count / total_weight) * 100
            }
            for class_name, weighted_count in class_weighted_votes.items()
        }
        
        return {
            'final_prediction': final_class,
            'confidence': avg_confidence,
            'vote_count': weighted_vote_count,
            'total_weight': total_weight,
            'votes': votes_detail,
            'model_predictions': model_results,
            'models_used': self.models_to_use,
            'voting_method': 'weighted_majority_voting',
            'model_weights': self.model_weights,
            'threshold': self.confidence_threshold,
            'total_models_attempted': len(self.models_to_use),
            'successful_predictions': len(all_predictions)
        }
    
    def classify_with_weighted_voting(self, image_path: str) -> Dict[str, Any]:
        """
        Classify using weighted voting (confidence-based)
        Higher confidence predictions get more weight
        
        Args:
            image_path: Path to the image file
            
        Returns:
            Dict with weighted voting results
        """
        all_predictions = []
        model_results = []
        
        # Get predictions from all models
        for model_key in self.models_to_use:
            try:
                model = get_yolo_model(model_key)
                predictions = model.predict(image_path)
                
                if predictions:
                    # Filter by confidence threshold
                    filtered_predictions = [
                        pred for pred in predictions 
                        if pred['confidence'] >= self.confidence_threshold
                    ]
                    
                    if filtered_predictions:
                        top_pred = filtered_predictions[0]
                        all_predictions.append({
                            'class_name': top_pred['class_name'],
                            'confidence': top_pred['confidence'],
                            'model': model_key
                        })
                        
                        model_results.append({
                            'model': model_key,
                            'prediction': top_pred['class_name'],
                            'confidence': top_pred['confidence']
                        })
            except Exception as e:
                print(f"Error with model {model_key}: {e}")
                continue
        
        if not all_predictions:
            return {
                'final_prediction': None,
                'confidence': 0.0,
                'weighted_scores': {},
                'model_predictions': model_results,
                'models_used': self.models_to_use
            }
        
        # Calculate weighted scores
        class_scores = {}
        for pred in all_predictions:
            class_name = pred['class_name']
            confidence = pred['confidence']
            
            if class_name not in class_scores:
                class_scores[class_name] = []
            class_scores[class_name].append(confidence)
        
        # Average confidence for each class
        weighted_scores = {
            class_name: sum(scores) / len(scores)
            for class_name, scores in class_scores.items()
        }
        
        # Get class with highest average confidence
        final_class = max(weighted_scores, key=weighted_scores.get)
        final_confidence = weighted_scores[final_class]
        
        return {
            'final_prediction': final_class,
            'confidence': final_confidence,
            'weighted_scores': weighted_scores,
            'model_predictions': model_results,
            'models_used': self.models_to_use,
            'voting_method': 'weighted_confidence'
        }
