import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import '../providers/tryon_provider.dart';
import '../../clothing/providers/clothing_provider.dart';

class TryOnResultScreen extends StatelessWidget {
  const TryOnResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Try-On Result'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareResult(context),
          ),
        ],
      ),
      body: Consumer<TryOnProvider>(
        builder: (context, tryOnProvider, child) {
          final currentTryOn = tryOnProvider.currentTryOn;
          
          if (currentTryOn == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No try-on result available',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Result Image Comparison
                _buildImageComparison(context, currentTryOn, tryOnProvider),
                
                // Clothing Info
                _buildClothingInfo(context, currentTryOn),
                
                // Confidence Score
                _buildConfidenceScore(currentTryOn),
                
                // Action Buttons
                _buildActionButtons(context, tryOnProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageComparison(BuildContext context, dynamic currentTryOn, TryOnProvider tryOnProvider) {
    return Container(
      height: 400,
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Original Image
          Expanded(
            child: Column(
              children: [
                const Text(
                  'Original',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: tryOnProvider.selectedImage != null
                          ? Image.file(
                              tryOnProvider.selectedImage!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )
                          : Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(Icons.person, size: 50),
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Result Image
          Expanded(
            child: Column(
              children: [
                const Text(
                  'Try-On Result',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.auto_fix_high, size: 40, color: Colors.grey),
                              SizedBox(height: 8),
                              Text('AI Result', style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClothingInfo(BuildContext context, dynamic currentTryOn) {
    return Consumer<ClothingProvider>(
      builder: (context, clothingProvider, child) {
        final clothing = clothingProvider.getClothingById(currentTryOn.clothingId);
        
        if (clothing == null) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Clothing Thumbnail
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.checkroom, color: Colors.grey),
                  ),
                  const SizedBox(width: 16),
                  
                  // Clothing Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          clothing.brand,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          clothing.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${clothing.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // View Details Button
                  IconButton(
                    onPressed: () {
                      context.go('/clothing/detail/${clothing.id}');
                    },
                    icon: const Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildConfidenceScore(dynamic currentTryOn) {
    final confidence = currentTryOn.confidence;
    final percentage = (confidence * 100).toInt();
    
    Color scoreColor;
    String scoreText;
    
    if (confidence >= 0.8) {
      scoreColor = Colors.green;
      scoreText = 'Excellent';
    } else if (confidence >= 0.6) {
      scoreColor = Colors.orange;
      scoreText = 'Good';
    } else {
      scoreColor = Colors.red;
      scoreText = 'Fair';
    }

    return Container(
      margin: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Try-On Quality',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: scoreColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: scoreColor),
                    ),
                    child: Text(
                      scoreText,
                      style: TextStyle(
                        color: scoreColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: confidence,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
              ),
              const SizedBox(height: 8),
              Text(
                '$percentage% match accuracy',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, TryOnProvider tryOnProvider) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Primary Actions
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _saveToFavorites(context),
                  icon: const Icon(Icons.favorite),
                  label: const Text('Save'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _shareResult(context),
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Secondary Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    tryOnProvider.clearCurrentTryOn();
                    context.go('/tryon');
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.go('/clothing');
                  },
                  icon: const Icon(Icons.checkroom),
                  label: const Text('Try Other'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _shareResult(BuildContext context) {
    // TODO: 实现分享功能
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share feature coming soon!')),
    );
  }

  void _saveToFavorites(BuildContext context) {
    // TODO: 实现保存到收藏功能
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved to favorites!')),
    );
  }
}