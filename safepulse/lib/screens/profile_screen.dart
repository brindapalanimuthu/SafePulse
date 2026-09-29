import 'package:flutter/material.dart';
import '../main.dart';
import '../services/sos_store.dart';
import '../theme/sos_theme.dart';
import '../widgets/sos_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const _languages = {
    'English': Locale('en'),
    'हिन्दी': Locale('hi'),
    'தமிழ்': Locale('ta'),
    'తెలుగు': Locale('te'),
    'ಕನ್ನಡ': Locale('kn'),
    'বাংলা': Locale('bn'),
  };

  final _s = SosStore.instance;
  late final _name = TextEditingController(text: _s.name);
  late final _phone = TextEditingController(text: _s.phone);
  late final _blood = TextEditingController(text: _s.bloodGroup);
  late final _note = TextEditingController(text: _s.note);

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _blood.dispose();
    _note.dispose();
    super.dispose();
  }

  void _save() {
    FocusScope.of(context).unfocus();
    _s.updateProfile(
      name: _name.text.trim(),
      phone: _phone.text.trim(),
      bloodGroup: _blood.text.trim(),
      note: _note.text.trim(),
    );
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile saved')));
  }

  @override
  Widget build(BuildContext context) {
    final current = Localizations.localeOf(context).languageCode;
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
        children: [
          Text('PROFILE', style: SosText.display(44)),
          const SizedBox(height: 6),
          Text('Shared with responders when you send an alert.', style: SosText.body(13, color: SosColors.muted)),
          const SizedBox(height: 20),
          TextField(controller: _name, textCapitalization: TextCapitalization.words, decoration: sosField('Name')),
          const SizedBox(height: 12),
          TextField(controller: _phone, keyboardType: TextInputType.phone, decoration: sosField('Phone number')),
          const SizedBox(height: 12),
          TextField(controller: _blood, decoration: sosField('Blood group (optional)', hint: 'e.g. O+')),
          const SizedBox(height: 12),
          TextField(controller: _note, maxLines: 3, decoration: sosField('Emergency note (optional)', hint: 'Allergies, medication, anything responders should know')),
          const SizedBox(height: 18),
          SizedBox(
            height: 52,
            child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: SosColors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
              onPressed: _save,
              child: Text('Save profile', style: SosText.body(14, color: Colors.white, weight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 28),
          Text('Language', style: SosText.body(12, color: SosColors.muted, weight: FontWeight.w600)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final e in _languages.entries)
                ChoiceChip(
                  label: Text(e.key),
                  selected: current == e.value.languageCode,
                  selectedColor: SosColors.red,
                  labelStyle: TextStyle(color: current == e.value.languageCode ? Colors.white : SosColors.ink),
                  onSelected: (_) => SafePulseApp.setLocale(context, e.value),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
