class ClothingModel {
  final String id;
  final String name;
  final String brand;
  final double price;
  final String category;
  final String imageUrl;
  final String description;
  final List<String> sizes;
  final List<String> colors;
  final double? rating;
  final int? reviewCount;

  ClothingModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.description,
    required this.sizes,
    required this.colors,
    this.rating,
    this.reviewCount,
  });

  factory ClothingModel.fromJson(Map<String, dynamic> json) {
    return ClothingModel(
      id: json['id'],
      name: json['name'],
      brand: json['brand'],
      price: json['price'].toDouble(),
      category: json['category'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      sizes: List<String>.from(json['sizes']),
      colors: List<String>.from(json['colors']),
      rating: json['rating']?.toDouble(),
      reviewCount: json['reviewCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'description': description,
      'sizes': sizes,
      'colors': colors,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }
}