import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/clothing_provider.dart';
import '../models/clothing_model.dart';

class ClothingDetailScreen extends StatelessWidget {
  final String clothingId;

  const ClothingDetailScreen({
    super.key,
    required this.clothingId,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ClothingProvider>(
      builder: (context, clothingProvider, child) {
        final clothing = clothingProvider.getClothingById(clothingId);
        
        if (clothing == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Not Found')),
            body: const Center(
              child: Text('Clothing item not found'),
            ),
          );
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.image,
                        size: 100,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      clothingProvider.isFavorite(clothingId)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: clothingProvider.isFavorite(clothingId)
                          ? Colors.red
                          : null,
                    ),
                    onPressed: () {
                      clothingProvider.toggleFavorite(clothingId);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () {
                      // TODO: 实现分享功能
                    },
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Brand and Name
                      Text(
                        clothing.brand,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        clothing.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Price and Rating
                      Row(
                        children: [
                          Text(
                            '\$${clothing.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const Spacer(),
                          if (clothing.rating != null) ...[
                            Icon(
                              Icons.star,
                              color: Colors.orange[400],
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${clothing.rating!.toStringAsFixed(1)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (clothing.reviewCount != null) ...[
                              const SizedBox(width: 4),
                              Text(
                                '(${clothing.reviewCount})',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ],
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Size Selection
                      _buildSizeSelection(clothing),
                      const SizedBox(height: 24),
                      
                      // Color Selection
                      _buildColorSelection(clothing),
                      const SizedBox(height: 24),
                      
                      // Description
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        clothing.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: 添加到购物车
                    },
                    icon: const Icon(Icons.shopping_cart_outlined),
                    label: const Text('Add to Cart'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.go('/tryon');
                      // TODO: 设置当前选择的服装
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Try On'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSizeSelection(ClothingModel clothing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Size',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: clothing.sizes.map((size) {
            return ChoiceChip(
              label: Text(size),
              selected: false, // TODO: 实现尺寸选择状态
              onSelected: (selected) {
                // TODO: 处理尺寸选择
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildColorSelection(ClothingModel clothing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Color',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          children: clothing.colors.map((colorName) {
            final color = _getColorFromName(colorName);
            return GestureDetector(
              onTap: () {
                // TODO: 处理颜色选择
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 2,
                  ),
                ),
                child: const Center(), // TODO: 添加选中状态指示器
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'purple':
        return Colors.purple;
      case 'orange':
        return Colors.orange;
      case 'pink':
        return Colors.pink;
      case 'gray':
      case 'grey':
        return Colors.grey;
      default:
        return Colors.grey[400]!;
    }
  }
}