import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/clothing_provider.dart';

class CategoryFilter extends StatelessWidget {
  const CategoryFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ClothingProvider>(
      builder: (context, clothingProvider, child) {
        return Container(
          height: 50,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              // All Categories Chip
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: const Text('All'),
                  selected: clothingProvider.selectedCategory == null,
                  onSelected: (selected) {
                    clothingProvider.setSelectedCategory(null);
                  },
                  selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                  checkmarkColor: Theme.of(context).primaryColor,
                ),
              ),
              
              // Category Chips
              ...clothingProvider.categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: clothingProvider.selectedCategory == category,
                    onSelected: (selected) {
                      clothingProvider.setSelectedCategory(
                        selected ? category : null,
                      );
                    },
                    selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                    checkmarkColor: Theme.of(context).primaryColor,
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}