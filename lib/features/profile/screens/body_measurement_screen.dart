import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';

class BodyMeasurementScreen extends StatefulWidget {
  const BodyMeasurementScreen({super.key});

  @override
  State<BodyMeasurementScreen> createState() => _BodyMeasurementScreenState();
}

class _BodyMeasurementScreenState extends State<BodyMeasurementScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  
  final List<MeasurementField> _measurementFields = [
    MeasurementField('height', 'Height (cm)', Icons.height, 'Enter your height'),
    MeasurementField('weight', 'Weight (kg)', Icons.monitor_weight, 'Enter your weight'),
    MeasurementField('chest', 'Chest (cm)', Icons.straighten, 'Chest circumference'),
    MeasurementField('waist', 'Waist (cm)', Icons.straighten, 'Waist circumference'),
    MeasurementField('hips', 'Hips (cm)', Icons.straighten, 'Hip circumference'),
    MeasurementField('shoulder', 'Shoulder (cm)', Icons.straighten, 'Shoulder width'),
    MeasurementField('sleeve', 'Sleeve (cm)', Icons.straighten, 'Sleeve length'),
    MeasurementField('inseam', 'Inseam (cm)', Icons.straighten, 'Inseam length'),
  ];

  @override
  void initState() {
    super.initState();
    for (final field in _measurementFields) {
      _controllers[field.key] = TextEditingController();
    }
    _loadExistingMeasurements();
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _loadExistingMeasurements() {
    final profileProvider = context.read<ProfileProvider>();
    final measurements = profileProvider.bodyMeasurements;
    
    for (final entry in measurements.entries) {
      if (_controllers.containsKey(entry.key)) {
        _controllers[entry.key]!.text = entry.value.toString();
      }
    }
  }

  Future<void> _saveMeasurements() async {
    if (_formKey.currentState!.validate()) {
      final measurements = <String, double>{};
      
      for (final entry in _controllers.entries) {
        final value = entry.value.text.trim();
        if (value.isNotEmpty) {
          measurements[entry.key] = double.tryParse(value) ?? 0.0;
        }
      }

      try {
        await context.read<ProfileProvider>().updateBodyMeasurements(measurements);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Measurements saved successfully!')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save measurements: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Body Measurements'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showMeasurementGuide,
          ),
        ],
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                // Info Card
                Container(
                  margin: const EdgeInsets.all(16),
                  child: Card(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Accurate measurements help provide better virtual try-on results. Fill in what you can.',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Measurement Fields
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _measurementFields.length,
                    itemBuilder: (context, index) {
                      final field = _measurementFields[index];
                      return _buildMeasurementField(field);
                    },
                  ),
                ),

                // Save Button
                Container(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: profileProvider.isLoading ? null : _saveMeasurements,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: profileProvider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Save Measurements',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMeasurementField(MeasurementField field) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              field.icon,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    field.label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _controllers[field.key],
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: field.hint,
                      suffixText: _getUnit(field.key),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    validator: (value) {
                      if (value?.isNotEmpty == true) {
                        final numValue = double.tryParse(value!);
                        if (numValue == null || numValue <= 0) {
                          return 'Please enter a valid number';
                        }
                        if (!_isValidRange(field.key, numValue)) {
                          return 'Value seems out of normal range';
                        }
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getUnit(String key) {
    switch (key) {
      case 'weight':
        return 'kg';
      default:
        return 'cm';
    }
  }

  bool _isValidRange(String key, double value) {
    switch (key) {
      case 'height':
        return value >= 100 && value <= 250;
      case 'weight':
        return value >= 30 && value <= 200;
      case 'chest':
        return value >= 60 && value <= 150;
      case 'waist':
        return value >= 50 && value <= 150;
      case 'hips':
        return value >= 60 && value <= 150;
      case 'shoulder':
        return value >= 30 && value <= 60;
      case 'sleeve':
        return value >= 50 && value <= 90;
      case 'inseam':
        return value >= 60 && value <= 100;
      default:
        return true;
    }
  }

  void _showMeasurementGuide() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Measurement Guide'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildGuideItem('Height', 'Stand straight against a wall and measure from floor to top of head'),
              _buildGuideItem('Chest', 'Measure around the fullest part of your chest'),
              _buildGuideItem('Waist', 'Measure around your natural waistline'),
              _buildGuideItem('Hips', 'Measure around the fullest part of your hips'),
              _buildGuideItem('Shoulder', 'Measure from shoulder point to shoulder point across your back'),
              _buildGuideItem('Sleeve', 'Measure from shoulder to wrist with arm extended'),
              _buildGuideItem('Inseam', 'Measure from crotch to ankle along inside of leg'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

class MeasurementField {
  final String key;
  final String label;
  final IconData icon;
  final String hint;

  MeasurementField(this.key, this.label, this.icon, this.hint);
}