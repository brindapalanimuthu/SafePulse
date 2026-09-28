import 'dart:io';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/classification_result.dart';
import '../services/classification_service.dart';
import '../widgets/photo_capture_sheet.dart';
import '../widgets/voice_capture_sheet.dart';
import 'emergency_response_screen.dart';

enum EmergencyCategory { fire, gasLeak, roadAccident, medical, flood, other }

extension EmergencyCategoryLabel on EmergencyCategory {
  // Fallback English label (used for debug/log output, not UI).
  String get label {
    switch (this) {
      case EmergencyCategory.fire:
        return 'Fire';
      case EmergencyCategory.gasLeak:
        return 'Gas leak';
      case EmergencyCategory.roadAccident:
        return 'Road accident';
      case EmergencyCategory.medical:
        return 'Medical';
      case EmergencyCategory.flood:
        return 'Flood';
      case EmergencyCategory.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case EmergencyCategory.fire:
        return Icons.local_fire_department;
      case EmergencyCategory.gasLeak:
        return Icons.gas_meter;
      case EmergencyCategory.roadAccident:
        return Icons.car_crash;
      case EmergencyCategory.medical:
        return Icons.medical_services;
      case EmergencyCategory.flood:
        return Icons.water;
      case EmergencyCategory.other:
        return Icons.help_outline;
    }
  }

  /// Localized label for display in the UI.
  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case EmergencyCategory.fire:
        return l10n.categoryFire;
      case EmergencyCategory.gasLeak:
        return l10n.categoryGasLeak;
      case EmergencyCategory.roadAccident:
        return l10n.categoryRoadAccident;
      case EmergencyCategory.medical:
        return l10n.categoryMedical;
      case EmergencyCategory.flood:
        return l10n.categoryFlood;
      case EmergencyCategory.other:
        return l10n.categoryOther;
    }
  }
}

class EmergencyClassificationScreen extends StatefulWidget {
  const EmergencyClassificationScreen({super.key});

  @override
  State<EmergencyClassificationScreen> createState() =>
      _EmergencyClassificationScreenState();
}

class _EmergencyClassificationScreenState
    extends State<EmergencyClassificationScreen> {
  EmergencyCategory? _selectedCategory;
  final ClassificationService _classificationService = ClassificationService();
  bool _isSubmitting = false;

  void _onCategorySelected(EmergencyCategory category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  Future<void> _onVoiceInputTap() async {
    final transcript = await VoiceCaptureSheet.show(context);
    if (transcript == null || transcript.isEmpty) return;

    setState(() => _isSubmitting = true);

    final result = await _classificationService.classifyText(transcript);

    setState(() => _isSubmitting = false);

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => EmergencyResponseScreen(result: result)),
    );
  }

  Future<void> _onPhotoInputTap() async {
    final File? photo = await PhotoCaptureSheet.show(context);
    if (photo == null) return;

    setState(() => _isSubmitting = true);

    final result = await _classificationService.classifyImage(photo);

    setState(() => _isSubmitting = false);

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => EmergencyResponseScreen(result: result)),
    );
  }

  Future<void> _onSubmit() async {
    if (_selectedCategory == null) return;

    setState(() => _isSubmitting = true);

    final ClassificationResult result =
        _classificationService.classifyManualSelection(_selectedCategory!);

    setState(() => _isSubmitting = false);

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => EmergencyResponseScreen(result: result)),
    );
  }

  @override
  void dispose() {
    _classificationService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.whatsHappening)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.selectCategory,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: EmergencyCategory.values.map((category) {
                final isSelected = _selectedCategory == category;
                return GestureDetector(
                  onTap: () => _onCategorySelected(category),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.redAccent : Colors.white,
                      border: Border.all(
                        color:
                            isSelected ? Colors.redAccent : Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          category.icon,
                          size: 32,
                          color: isSelected ? Colors.white : Colors.redAccent,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category.localizedLabel(l10n),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _onVoiceInputTap,
                    icon: const Icon(Icons.mic),
                    label: Text(l10n.voiceInput),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _onPhotoInputTap,
                    icon: const Icon(Icons.camera_alt),
                    label: Text(l10n.photoInput),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed:
                  (_selectedCategory == null || _isSubmitting) ? null : _onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(l10n.sendForHelp),
            ),
          ],
        ),
      ),
    );
  }
}
