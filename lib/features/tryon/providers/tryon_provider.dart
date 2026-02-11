import 'package:flutter/material.dart';
import 'dart:io';
import '../models/tryon_model.dart';

class TryOnProvider extends ChangeNotifier {
  List<TryOnModel> _tryOnHistory = [];
  TryOnModel? _currentTryOn;
  File? _selectedImage;
  bool _isProcessing = false;
  String? _selectedClothingId;

  List<TryOnModel> get tryOnHistory => _tryOnHistory;
  TryOnModel? get currentTryOn => _currentTryOn;
  File? get selectedImage => _selectedImage;
  bool get isProcessing => _isProcessing;
  String? get selectedClothingId => _selectedClothingId;

  void setSelectedImage(File? image) {
    _selectedImage = image;
    notifyListeners();
  }

  void setSelectedClothing(String clothingId) {
    _selectedClothingId = clothingId;
    notifyListeners();
  }

  Future<void> processTryOn() async {
    if (_selectedImage == null || _selectedClothingId == null) {
      throw Exception('Please select both image and clothing item');
    }

    _isProcessing = true;
    notifyListeners();

    try {
      // TODO: 实现真实的AI试衣API调用
      await Future.delayed(const Duration(seconds: 3));

      final tryOnResult = TryOnModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        originalImagePath: _selectedImage!.path,
        resultImageUrl: 'https://example.com/result.jpg', // 模拟结果
        clothingId: _selectedClothingId!,
        timestamp: DateTime.now(),
        confidence: 0.85,
      );

      _currentTryOn = tryOnResult;
      _tryOnHistory.insert(0, tryOnResult);

      if (_tryOnHistory.length > 50) {
        _tryOnHistory = _tryOnHistory.take(50).toList();
      }

    } catch (e) {
      throw Exception('Try-on processing failed: $e');
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  void clearCurrentTryOn() {
    _currentTryOn = null;
    _selectedImage = null;
    _selectedClothingId = null;
    notifyListeners();
  }

  void deleteTryOnFromHistory(String id) {
    _tryOnHistory.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  Future<void> loadTryOnHistory() async {
    // TODO: 从本地数据库加载历史记录
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      // 模拟数据
      _tryOnHistory = [];
    } catch (e) {
      throw Exception('Failed to load try-on history: $e');
    }
  }

  Future<void> saveTryOn(TryOnModel tryOn) async {
    // TODO: 保存到本地数据库
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      // 保存逻辑
    } catch (e) {
      throw Exception('Failed to save try-on result: $e');
    }
  }
}