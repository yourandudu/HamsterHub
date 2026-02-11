import 'package:flutter/material.dart';
import '../models/clothing_model.dart';

class ClothingProvider extends ChangeNotifier {
  List<ClothingModel> _clothingItems = [];
  List<ClothingModel> _favoriteItems = [];
  List<String> _categories = [];
  String? _selectedCategory;
  bool _isLoading = false;
  String _searchQuery = '';

  List<ClothingModel> get clothingItems => _clothingItems;
  List<ClothingModel> get favoriteItems => _favoriteItems;
  List<String> get categories => _categories;
  String? get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  List<ClothingModel> get filteredClothing {
    var items = _clothingItems;
    
    if (_selectedCategory != null) {
      items = items.where((item) => item.category == _selectedCategory).toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      items = items.where((item) => 
        item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        item.brand.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    return items;
  }

  Future<void> loadClothingItems() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: 替换为真实API调用
      await Future.delayed(const Duration(seconds: 1));
      
      _clothingItems = [
        ClothingModel(
          id: '1',
          name: 'Classic White T-Shirt',
          brand: 'BasicWear',
          price: 29.99,
          category: 'T-Shirts',
          imageUrl: 'https://example.com/tshirt1.jpg',
          description: 'Comfortable cotton t-shirt perfect for everyday wear.',
          sizes: ['S', 'M', 'L', 'XL'],
          colors: ['White', 'Black', 'Gray'],
        ),
        ClothingModel(
          id: '2',
          name: 'Denim Jacket',
          brand: 'DenimCo',
          price: 79.99,
          category: 'Jackets',
          imageUrl: 'https://example.com/jacket1.jpg',
          description: 'Stylish denim jacket for casual outings.',
          sizes: ['S', 'M', 'L', 'XL'],
          colors: ['Blue', 'Black'],
        ),
      ];
      
      _categories = ['T-Shirts', 'Jackets', 'Pants', 'Dresses', 'Shoes'];
    } catch (e) {
      throw Exception('Failed to load clothing items: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSelectedCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleFavorite(String clothingId) {
    final item = _clothingItems.firstWhere((item) => item.id == clothingId);
    
    if (_favoriteItems.any((fav) => fav.id == clothingId)) {
      _favoriteItems.removeWhere((fav) => fav.id == clothingId);
    } else {
      _favoriteItems.add(item);
    }
    
    notifyListeners();
  }

  bool isFavorite(String clothingId) {
    return _favoriteItems.any((item) => item.id == clothingId);
  }

  ClothingModel? getClothingById(String id) {
    try {
      return _clothingItems.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }
}