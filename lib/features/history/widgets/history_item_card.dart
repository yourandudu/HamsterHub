import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../clothing/providers/clothing_provider.dart';
import 'package:provider/provider.dart';

class HistoryItemCard extends StatelessWidget {
  final dynamic tryOnResult;
  final VoidCallback onTap;
  final VoidCallback onShare;
  final VoidCallback onDelete;
  final VoidCallback onRetry;

  const HistoryItemCard({
    super.key,
    required this.tryOnResult,
    required this.onTap,
    required this.onShare,
    required this.onDelete,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final timestamp = tryOnResult.timestamp as DateTime;
    final formattedDate = DateFormat('MMM dd, yyyy HH:mm').format(timestamp);
    final confidence = tryOnResult.confidence as double;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Preview Section
            Container(
              height: 200,
              child: Row(
                children: [
                  // Original Image
                  Expanded(
                    child: Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person, size: 40, color: Colors.grey),
                            SizedBox(height: 4),
                            Text('Original', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(width: 2, color: Colors.white),
                  // Result Image
                  Expanded(
                    child: Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.auto_fix_high, size: 40, color: Colors.grey),
                            SizedBox(height: 4),
                            Text('Result', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Clothing Info
                  Consumer<ClothingProvider>(
                    builder: (context, clothingProvider, child) {
                      final clothing = clothingProvider.getClothingById(tryOnResult.clothingId);
                      
                      return Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.checkroom, size: 20, color: Colors.grey),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  clothing?.name ?? 'Unknown Item',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  clothing?.brand ?? 'Unknown Brand',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (clothing != null)
                            Text(
                              '\$${clothing.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // Confidence Score
                  Row(
                    children: [
                      Icon(
                        Icons.verified,
                        size: 16,
                        color: _getConfidenceColor(confidence),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${(confidence * 100).toInt()}% match',
                        style: TextStyle(
                          fontSize: 14,
                          color: _getConfidenceColor(confidence),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        icon: Icons.refresh,
                        label: 'Retry',
                        onPressed: onRetry,
                      ),
                      _buildActionButton(
                        icon: Icons.share,
                        label: 'Share',
                        onPressed: onShare,
                      ),
                      _buildActionButton(
                        icon: Icons.delete_outline,
                        label: 'Delete',
                        onPressed: onDelete,
                        color: Colors.red[400],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16, color: color),
      label: Text(
        label,
        style: TextStyle(fontSize: 12, color: color),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: const Size(0, 32),
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) {
      return Colors.green;
    } else if (confidence >= 0.6) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}