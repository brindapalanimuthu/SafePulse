import 'dart:io';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/classification_result.dart';
import '../services/classification_service.dart';
import '../theme/sos_theme.dart';
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

  Widget _categoryCard(EmergencyCategory category, AppLocalizations l10n) {
    final selected = _selectedCategory == category;
    final label = category.localizedLabel(l10n);
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: selected ? SosColors.red : Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => _onCategorySelected(category),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: selected ? SosColors.red : SosColors.line, width: selected ? 1.5 : 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(category.icon, size: 30, color: selected ? Colors.white : SosColors.red),
                const SizedBox(height: 10),
                Text(
                  label,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: SosText.body(14, color: selected ? Colors.white : SosColors.ink, weight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ButtonStyle get _outlineStyle => OutlinedButton.styleFrom(
        foregroundColor: SosColors.ink,
        backgroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        side: const BorderSide(color: Color(0xFFD8D8DD)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: SosColors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 0, 0),
                child: IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(l10n.whatsHappening.toUpperCase(), style: SosText.display(40)),
                    const SizedBox(height: 6),
                    Text(l10n.selectCategory, style: SosText.body(13, color: SosColors.muted)),
                    const SizedBox(height: 20),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: EmergencyCategory.values.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        mainAxisExtent: 112,
                      ),
                      itemBuilder: (_, i) => _categoryCard(EmergencyCategory.values[i], l10n),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: _outlineStyle,
                            onPressed: _onVoiceInputTap,
                            icon: const Icon(Icons.mic_none_rounded),
                            label: Text(l10n.voiceInput, maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: _outlineStyle,
                            onPressed: _onPhotoInputTap,
                            icon: const Icon(Icons.photo_camera_outlined),
                            label: Text(l10n.photoInput, maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: SizedBox(
                width: double.infinity,
                height: 58,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: SosColors.black,
                    disabledBackgroundColor: const Color(0xFFCFCFD4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  onPressed: (_selectedCategory == null || _isSubmitting) ? null : _onSubmit,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(l10n.sendForHelp, style: SosText.body(15, color: Colors.white, weight: FontWeight.w700)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}