class TryOnModel {
  final String id;
  final String originalImagePath;
  final String resultImageUrl;
  final String clothingId;
  final DateTime timestamp;
  final double confidence;
  final String? notes;

  TryOnModel({
    required this.id,
    required this.originalImagePath,
    required this.resultImageUrl,
    required this.clothingId,
    required this.timestamp,
    required this.confidence,
    this.notes,
  });

  factory TryOnModel.fromJson(Map<String, dynamic> json) {
    return TryOnModel(
      id: json['id'],
      originalImagePath: json['originalImagePath'],
      resultImageUrl: json['resultImageUrl'],
      clothingId: json['clothingId'],
      timestamp: DateTime.parse(json['timestamp']),
      confidence: json['confidence'].toDouble(),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'originalImagePath': originalImagePath,
      'resultImageUrl': resultImageUrl,
      'clothingId': clothingId,
      'timestamp': timestamp.toIso8601String(),
      'confidence': confidence,
      'notes': notes,
    };
  }
}