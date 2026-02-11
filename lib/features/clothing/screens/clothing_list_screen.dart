import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/clothing_provider.dart';
import '../widgets/clothing_card.dart';
import '../widgets/category_filter.dart';

class ClothingListScreen extends StatefulWidget {
  const ClothingListScreen({super.key});

  @override
  State<ClothingListScreen> createState() => _ClothingListScreenState();
}

class _ClothingListScreenState extends State<ClothingListScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClothingProvider>().loadClothingItems();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clothing'),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search clothing...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<ClothingProvider>().setSearchQuery('');
                  },
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                context.read<ClothingProvider>().setSearchQuery(value);
              },
            ),
          ),
        ),
      ),
      body: Consumer<ClothingProvider>(
        builder: (context, clothingProvider, child) {
          if (clothingProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            children: [
              // Category Filter
              const CategoryFilter(),
              
              // Clothing Grid
              Expanded(
                child: clothingProvider.filteredClothing.isEmpty
                    ? _buildEmptyState()
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: clothingProvider.filteredClothing.length,
                          itemBuilder: (context, index) {
                            final clothing = clothingProvider.filteredClothing[index];
                            return ClothingCard(
                              clothing: clothing,
                              onTap: () {
                                context.go('/clothing/detail/${clothing.id}');
                              },
                              onFavorite: () {
                                clothingProvider.toggleFavorite(clothing.id);
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
          context.go('/tryon');
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No clothing found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}