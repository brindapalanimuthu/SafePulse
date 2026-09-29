import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrustedContact {
  final String name;
  final String phone;
  const TrustedContact({required this.name, required this.phone});

  Map<String, dynamic> toJson() => {'name': name, 'phone': phone};
  factory TrustedContact.fromJson(Map<String, dynamic> j) =>
      TrustedContact(name: '${j['name']}', phone: '${j['phone']}');
}

class ActivityEntry {
  final DateTime time;
  final String title;
  const ActivityEntry({required this.time, required this.title});

  Map<String, dynamic> toJson() => {'time': time.toIso8601String(), 'title': title};
  factory ActivityEntry.fromJson(Map<String, dynamic> j) =>
      ActivityEntry(time: DateTime.tryParse('${j['time']}') ?? DateTime.now(), title: '${j['title']}');
}

/// Local storage for contacts, activity log and profile. Call [load] once in main().
class SosStore extends ChangeNotifier {
  SosStore._();
  static final SosStore instance = SosStore._();

  SharedPreferences? _p;
  List<TrustedContact> contacts = [];
  List<ActivityEntry> activity = [];
  String name = '';
  String phone = '';
  String bloodGroup = '';
  String note = '';

  Future<void> load() async {
    _p = await SharedPreferences.getInstance();
    contacts = _list('contacts', TrustedContact.fromJson);
    activity = _list('activity', ActivityEntry.fromJson);
    name = _p!.getString('name') ?? '';
    phone = _p!.getString('phone') ?? '';
    bloodGroup = _p!.getString('bloodGroup') ?? '';
    note = _p!.getString('note') ?? '';
    notifyListeners();
  }

  List<T> _list<T>(String key, T Function(Map<String, dynamic>) f) {
    final raw = _p?.getString(key);
    if (raw == null) return [];
    try {
      return (jsonDecode(raw) as List).map((e) => f(Map<String, dynamic>.from(e as Map))).toList();
    } catch (_) {
      return [];
    }
  }

  void _save() {
    _p?.setString('contacts', jsonEncode(contacts.map((c) => c.toJson()).toList()));
    _p?.setString('activity', jsonEncode(activity.map((a) => a.toJson()).toList()));
    _p?.setString('name', name);
    _p?.setString('phone', phone);
    _p?.setString('bloodGroup', bloodGroup);
    _p?.setString('note', note);
    notifyListeners();
  }

  void addContact(TrustedContact c) {
    contacts = [...contacts, c];
    _save();
  }

  void removeContact(TrustedContact c) {
    contacts = contacts.where((x) => x != c).toList();
    _save();
  }

  void logActivity(String title) {
    activity = [ActivityEntry(time: DateTime.now(), title: title), ...activity].take(50).toList();
    _save();
  }

  void clearActivity() {
    activity = [];
    _save();
  }

  void updateProfile({required String name, required String phone, required String bloodGroup, required String note}) {
    this.name = name;
    this.phone = phone;
    this.bloodGroup = bloodGroup;
    this.note = note;
    _save();
  }
}
