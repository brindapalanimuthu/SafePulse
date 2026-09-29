import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../l10n/app_localizations.dart';

/// Bottom sheet that lets the user take a photo or pick one from the
/// gallery, preview it, and confirm. Returns the picked File (or null
/// if cancelled).
class PhotoCaptureSheet extends StatefulWidget {
  const PhotoCaptureSheet({super.key});

  @override
  State<PhotoCaptureSheet> createState() => _PhotoCaptureSheetState();

  static Future<File?> show(BuildContext context) {
    return showModalBottomSheet<File>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const PhotoCaptureSheet(),
    );
  }
}

class _PhotoCaptureSheetState extends State<PhotoCaptureSheet> {
  final ImagePicker _picker = ImagePicker();
  File? _pickedFile;
  String? _errorText;

  Future<void> _pickImage(ImageSource source) async {
    setState(() => _errorText = null);
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (file == null) return;
      setState(() => _pickedFile = File(file.path));
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorText = AppLocalizations.of(context)!.cameraError('$e'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            t.addPhoto,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          if (_pickedFile != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(_pickedFile!, height: 220, fit: BoxFit.cover),
            )
          else
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.image, size: 48, color: Colors.grey),
              ),
            ),
          if (_errorText != null) ...[
            const SizedBox(height: 8),
            Text(_errorText!, style: const TextStyle(color: Colors.red)),
          ],
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: Text(t.camera),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: Text(t.gallery),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(t.cancel),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _pickedFile == null
                      ? null
                      : () => Navigator.of(context).pop(_pickedFile),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(t.usePhoto),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}