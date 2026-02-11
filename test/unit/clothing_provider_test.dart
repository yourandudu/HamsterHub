import 'package:flutter_test/flutter_test.dart';
import 'package:tryon/features/clothing/providers/clothing_provider.dart';
import 'package:tryon/features/clothing/models/clothing_model.dart';

void main() {
  group('ClothingProvider Tests', () {
    late ClothingProvider clothingProvider;

    setUp(() {
      clothingProvider = ClothingProvider();
    });

    test('initial state is empty', () {
      expect(clothingProvider.clothingItems, isEmpty);
      expect(clothingProvider.favoriteItems, isEmpty);
      expect(clothingProvider.categories, isEmpty);
      expect(clothingProvider.isLoading, false);
    });

    test('loadClothingItems sets loading state correctly', () async {
      // Start loading
      final loadingFuture = clothingProvider.loadClothingItems();
      expect(clothingProvider.isLoading, true);

      // Wait for completion
      await loadingFuture;
      expect(clothingProvider.isLoading, false);
      expect(clothingProvider.clothingItems, isNotEmpty);
      expect(clothingProvider.categories, isNotEmpty);
    });

    test('toggleFavorite adds and removes items correctly', () {
      // Arrange - create mock clothing item
      final clothingItem = ClothingModel(
        id: '1',
        name: 'Test T-Shirt',
        brand: 'TestBrand',
        price: 29.99,
        category: 'T-Shirts',
        imageUrl: 'https://example.com/image.jpg',
        description: 'Test description',
        sizes: ['S', 'M', 'L'],
        colors: ['White', 'Black'],
      );

      // Manually add to items list for testing
      clothingProvider.clothingItems.add(clothingItem);

      // Act - toggle favorite
      clothingProvider.toggleFavorite('1');

      // Assert - item should be in favorites
      expect(clothingProvider.favoriteItems, hasLength(1));
      expect(clothingProvider.isFavorite('1'), true);

      // Act - toggle again
      clothingProvider.toggleFavorite('1');

      // Assert - item should be removed from favorites
      expect(clothingProvider.favoriteItems, isEmpty);
      expect(clothingProvider.isFavorite('1'), false);
    });

    test('setSelectedCategory filters items correctly', () async {
      // Arrange - load items first
      await clothingProvider.loadClothingItems();
      
      // Act - set category filter
      clothingProvider.setSelectedCategory('T-Shirts');

      // Assert
      expect(clothingProvider.selectedCategory, 'T-Shirts');
      expect(clothingProvider.filteredClothing, isNotEmpty);
    });

    test('setSearchQuery filters items correctly', () async {
      // Arrange - load items first
      await clothingProvider.loadClothingItems();
      
      // Act - set search query
      clothingProvider.setSearchQuery('Classic');

      // Assert
      expect(clothingProvider.searchQuery, 'Classic');
      expect(clothingProvider.filteredClothing, isNotEmpty);
    });

    test('getClothingById returns correct item', () async {
      // Arrange - load items first
      await clothingProvider.loadClothingItems();
      
      // Act
      final item = clothingProvider.getClothingById('1');

      // Assert
      expect(item, isNotNull);
      expect(item?.id, '1');
    });

    test('getClothingById returns null for non-existent item', () {
      // Act
      final item = clothingProvider.getClothingById('non-existent');

      // Assert
      expect(item, null);
    });

    test('filtered clothing respects both category and search', () async {
      // Arrange - load items first
      await clothingProvider.loadClothingItems();
      
      // Act - set both filters
      clothingProvider.setSelectedCategory('T-Shirts');
      clothingProvider.setSearchQuery('Classic');

      // Assert - should filter by both criteria
      final filtered = clothingProvider.filteredClothing;
      expect(filtered.every((item) => 
        item.category == 'T-Shirts' && 
        item.name.toLowerCase().contains('classic')), true);
    });
  });
}