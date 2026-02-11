import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../providers/tryon_provider.dart';
import '../../clothing/providers/clothing_provider.dart';

class TryOnCameraScreen extends StatefulWidget {
  const TryOnCameraScreen({super.key});

  @override
  State<TryOnCameraScreen> createState() => _TryOnCameraScreenState();
}

class _TryOnCameraScreenState extends State<TryOnCameraScreen> {
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TryOnProvider>().clearCurrentTryOn();
    });
  }

  Future<void> _selectImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null && mounted) {
        context.read<TryOnProvider>().setSelectedImage(File(image.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to select image: $e')),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _selectImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _selectImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Virtual Try-On'),
        centerTitle: true,
      ),
      body: Consumer<TryOnProvider>(
        builder: (context, tryOnProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Instructions
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 32,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'How it works',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '1. Take or upload a photo of yourself\n2. Select clothing to try on\n3. Get AI-powered virtual try-on result',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Image Selection Section
                _buildImageSection(tryOnProvider),
                const SizedBox(height: 24),

                // Clothing Selection Section
                _buildClothingSelectionSection(tryOnProvider),
                const SizedBox(height: 32),

                // Process Button
                ElevatedButton(
                  onPressed: _canProcess(tryOnProvider) ? () => _processTryOn() : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: tryOnProvider.isProcessing
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text('Processing...'),
                          ],
                        )
                      : const Text(
                          'Start Virtual Try-On',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageSection(TryOnProvider tryOnProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Photo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _showImageSourceDialog,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey[300]!,
                    style: BorderStyle.solid,
                  ),
                ),
                child: tryOnProvider.selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          tryOnProvider.selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap to add photo',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Camera or Gallery',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            if (tryOnProvider.selectedImage != null) ...[
              const SizedBox(height: 8),
              Center(
                child: TextButton.icon(
                  onPressed: _showImageSourceDialog,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Change Photo'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildClothingSelectionSection(TryOnProvider tryOnProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Clothing',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.go('/clothing');
                  },
                  child: const Text('Browse All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Consumer<ClothingProvider>(
              builder: (context, clothingProvider, child) {
                if (clothingProvider.clothingItems.isEmpty) {
                  return Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text('No clothing available'),
                    ),
                  );
                }

                return SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: clothingProvider.clothingItems.length,
                    itemBuilder: (context, index) {
                      final clothing = clothingProvider.clothingItems[index];
                      final isSelected = tryOnProvider.selectedClothingId == clothing.id;
                      
                      return GestureDetector(
                        onTap: () {
                          tryOnProvider.setSelectedClothing(clothing.id);
                        },
                        child: Container(
                          width: 80,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected 
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey[300]!,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(8),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.checkroom,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: Text(
                                  clothing.name,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: isSelected 
                                        ? FontWeight.bold 
                                        : FontWeight.normal,
                                    color: isSelected 
                                        ? Theme.of(context).primaryColor
                                        : Colors.black,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  bool _canProcess(TryOnProvider tryOnProvider) {
    return tryOnProvider.selectedImage != null &&
           tryOnProvider.selectedClothingId != null &&
           !tryOnProvider.isProcessing;
  }

  Future<void> _processTryOn() async {
    try {
      await context.read<TryOnProvider>().processTryOn();
      if (mounted) {
        context.go('/tryon/result');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Try-on failed: $e')),
        );
      }
    }
  }
}