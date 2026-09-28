import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../l10n/app_localizations.dart';
import '../models/classification_result.dart';
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
  // Android emulator: 10.0.2.2 reaches your Mac. iOS simulator: use
  // --dart-define=NOTIFY_URL=http://localhost:3000/api/ndma/notify
  // Real phone: use your Mac's LAN IP or a deployed URL.
  static const String _notifyUrl = String.fromEnvironment(
    'NOTIFY_URL',
    defaultValue: 'http://10.0.2.2:3000/api/ndma/notify',
  );

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
            }),
          )
          .timeout(const Duration(seconds: 8));

      if (!mounted) return;
      if (response.statusCode == 200) {
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
      backgroundColor: Colors.red.shade50,
      appBar: AppBar(
        title: Text(widget.result.category.localizedLabel(l10n)),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.redAccent),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        locationText,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CalmModeScreen(firstAidSteps: steps),
                  ),
                );
              },
              icon: const Icon(Icons.self_improvement),
              label: Text(l10n.enterCalmMode),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.whatToDoNow,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ...steps.map(
              (step) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle,
                        color: Colors.redAccent, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(step)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_dispatched)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 12),
                    Expanded(child: Text(l10n.helpNotified)),
                  ],
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_dispatchError != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        _dispatchError!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ElevatedButton(
                    onPressed: _dispatching ? null : _dispatchHelp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _dispatching
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(l10n.notifyHelp),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}