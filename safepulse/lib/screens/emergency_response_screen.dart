import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../l10n/app_localizations.dart';
import '../models/classification_result.dart';
import '../services/sos_store.dart';
import '../theme/sos_theme.dart';
import 'emergency_classification_screen.dart';
import 'calm_mode_screen.dart';

class EmergencyResponseScreen extends StatefulWidget {
  final ClassificationResult result;

  const EmergencyResponseScreen({super.key, required this.result});

  @override
  State<EmergencyResponseScreen> createState() =>
      _EmergencyResponseScreenState();
}

class _EmergencyResponseScreenState extends State<EmergencyResponseScreen> {
  // Set per device with --dart-define=BACKEND_URL=... (see config.dart)
  static const String _notifyUrl = '${Config.backendUrl}/api/ndma/notify';

  Position? _position;
  bool _locationFetched = false;
  String _locationErrorKey = '';
  bool _dispatched = false;
  bool _dispatching = false;
  String? _dispatchError;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!mounted) return;
      if (!serviceEnabled) {
        setState(() => _locationErrorKey = 'disabled');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (!mounted) return;
        if (permission == LocationPermission.denied) {
          setState(() => _locationErrorKey = 'denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => _locationErrorKey = 'deniedForever');
        return;
      }

      final position = await Geolocator.getCurrentPosition().timeout(
        const Duration(seconds: 8),
        onTimeout: () => throw Exception('Location request timed out'),
      );
      if (!mounted) return;
      setState(() {
        _position = position;
        _locationFetched = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _locationErrorKey = 'error');
    }
  }

  Future<void> _dispatchHelp() async {
    setState(() {
      _dispatching = true;
      _dispatchError = null;
    });

    try {
      final store = SosStore.instance;
      final response = await http
          .post(
            Uri.parse(_notifyUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'category': widget.result.category.name,
              'confidence': widget.result.confidence,
              'latitude': _position?.latitude ?? 0.0,
              'longitude': _position?.longitude ?? 0.0,
              'timestamp': DateTime.now().toIso8601String(),
              // Added: who is asking and who to notify (from Profile / Contacts tabs)
              'reporter': {
                'name': store.name,
                'phone': store.phone,
                'bloodGroup': store.bloodGroup,
                'note': store.note,
              },
              'contacts': store.contacts.map((c) => c.toJson()).toList(),
            }),
          )
          .timeout(const Duration(seconds: 8));

      if (!mounted) return;
      if (response.statusCode == 200) {
        store.logActivity('Alert sent: ${widget.result.category.label}');
        setState(() {
          _dispatched = true;
          _dispatching = false;
        });
      } else {
        setState(() {
          _dispatching = false;
          _dispatchError = 'Server responded with ${response.statusCode}';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _dispatching = false;
        _dispatchError = 'Could not reach server: $e';
      });
    }
  }

  String _locationErrorMessage() {
    switch (_locationErrorKey) {
      case 'disabled':
        return 'Location services are turned off. Please enable them.';
      case 'denied':
        return 'Location permission denied.';
      case 'deniedForever':
        return 'Location permission permanently denied. Enable it in Settings.';
      default:
        return 'Could not get your location.';
    }
  }

  List<String> _firstAidSteps(AppLocalizations l10n) {
    switch (widget.result.category) {
      case EmergencyCategory.fire:
        return [
          'Get low and move away from smoke.',
          'Do not use elevators.',
          'If trapped, seal door gaps with cloth and signal from a window.',
          'Do not re-enter the building for belongings.',
        ];
      case EmergencyCategory.gasLeak:
        return [
          'Do not switch on/off any electrical device or light a flame.',
          'Open windows and doors if safe to do so.',
          'Leave the area immediately and move upwind.',
          'Do not return until cleared by authorities.',
        ];
      case EmergencyCategory.roadAccident:
        return [
          'Do not move injured persons unless there is immediate danger.',
          'Turn on hazard lights and place warning triangles if available.',
          'Apply pressure to any severe external bleeding.',
          'Keep the person calm and still until help arrives.',
        ];
      case EmergencyCategory.medical:
        return [
          'Keep the person calm and comfortable.',
          'Do not give food or water if they are unconscious.',
          'If not breathing, begin CPR if trained.',
          'Note the time symptoms started for responders.',
        ];
      case EmergencyCategory.flood:
        return [
          'Move to higher ground immediately.',
          'Avoid walking or driving through moving water.',
          'Stay away from downed power lines.',
          'Keep away from storm drains and fast-moving water.',
        ];
      case EmergencyCategory.other:
        return [
          'Stay calm and move to a safe location.',
          'Keep your phone charged and accessible.',
          'Wait for a responder to make contact.',
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final steps = _firstAidSteps(l10n);
    final category = widget.result.category;

    final String locationText;
    if (_locationFetched && _position != null) {
      locationText =
          '${_position!.latitude.toStringAsFixed(5)}, ${_position!.longitude.toStringAsFixed(5)}';
    } else if (_locationErrorKey.isNotEmpty) {
      locationText = _locationErrorMessage();
    } else {
      locationText = l10n.locationFetching;
    }

    return Scaffold(
      backgroundColor: SosColors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(color: SosColors.red, shape: BoxShape.circle),
                        child: Icon(category.icon, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          category.localizedLabel(l10n).toUpperCase(),
                          style: SosText.display(44),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: SosColors.line),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: SosColors.red),
                        const SizedBox(width: 12),
                        Expanded(child: Text(locationText, style: SosText.body(14, weight: FontWeight.w600))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 52,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: SosColors.ink,
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: SosColors.ink, width: 1.2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CalmModeScreen(firstAidSteps: steps),
                          ),
                        );
                      },
                      icon: const Icon(Icons.self_improvement),
                      label: Text(l10n.enterCalmMode, style: SosText.body(14, weight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(l10n.whatToDoNow, style: SosText.body(12, color: SosColors.muted, weight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  ...steps.map(
                    (step) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            margin: const EdgeInsets.only(top: 1),
                            decoration: const BoxDecoration(color: SosColors.red, shape: BoxShape.circle),
                            child: const Icon(Icons.check_rounded, color: Colors.white, size: 15),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(step, style: SosText.body(14.5))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: _dispatched
                  ? Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF2E9E5B), width: 1.5),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Color(0xFF2E9E5B)),
                          const SizedBox(width: 12),
                          Expanded(child: Text(l10n.helpNotified, style: SosText.body(14, weight: FontWeight.w600))),
                        ],
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_dispatchError != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(_dispatchError!, style: SosText.body(12.5, color: SosColors.redDeep)),
                          ),
                        SizedBox(
                          height: 58,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: SosColors.red,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            ),
                            onPressed: _dispatching ? null : _dispatchHelp,
                            child: _dispatching
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : Text(l10n.notifyHelp, style: SosText.body(15, color: Colors.white, weight: FontWeight.w700)),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}