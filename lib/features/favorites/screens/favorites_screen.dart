import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../clothing/providers/clothing_provider.dart';
import '../../clothing/widgets/clothing_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClothingProvider>().loadClothingItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
          ),
        ],
      ),
      body: Consumer<ClothingProvider>(
        builder: (context, clothingProvider, child) {
          final favoriteItems = clothingProvider.favoriteItems;

          if (favoriteItems.isEmpty) {
            return _buildEmptyState();
          }

          return Column(
            children: [
              // Header with count
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Colors.red[400],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${favoriteItems.length} favorite items',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: _showClearDialog,
                      child: const Text('Clear All'),
                    ),
                  ],
                ),
              ),

              // Favorites Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: favoriteItems.length,
                    itemBuilder: (context, index) {
                      final clothing = favoriteItems[index];
                      return ClothingCard(
                        clothing: clothing,
                        onTap: () {
                          context.go('/clothing/detail/${clothing.id}');
                        },
                        onFavorite: () {
                          clothingProvider.toggleFavorite(clothing.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Removed from favorites'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/clothing');
        },
        child: const Icon(Icons.add),
        tooltip: 'Browse Clothing',
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          const Text(
            'No Favorites Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Start adding items to your favorites\nby tapping the heart icon',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              context.go('/clothing');
            },
            icon: const Icon(Icons.shopping_bag),
            label: const Text('Browse Clothing'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String searchQuery = '';
        return AlertDialog(
          title: const Text('Search Favorites'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter clothing name or brand...',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              searchQuery = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (searchQuery.isNotEmpty) {
                  // TODO: 实现搜索功能
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Searching for: $searchQuery')),
                  );
                }
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }

  void _showClearDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Favorites'),
        content: const Text('Are you sure you want to remove all items from favorites?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _clearAllFavorites();
            },
            child: const Text(
              'Clear All',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _clearAllFavorites() {
    final clothingProvider = context.read<ClothingProvider>();
    final favoriteIds = clothingProvider.favoriteItems.map((item) => item.id).toList();
    
    for (final id in favoriteIds) {
      clothingProvider.toggleFavorite(id);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All favorites cleared'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}