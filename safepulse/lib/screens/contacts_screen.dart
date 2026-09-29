import 'package:flutter/material.dart';
import '../services/sos_store.dart';
import '../theme/sos_theme.dart';
import '../widgets/sos_field.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  void _add(BuildContext context) {
    final name = TextEditingController();
    final phone = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: SosColors.canvas,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 24, 20, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('ADD CONTACT', style: SosText.display(28)),
          const SizedBox(height: 16),
          TextField(controller: name, textCapitalization: TextCapitalization.words, decoration: sosField('Name')),
          const SizedBox(height: 12),
          TextField(controller: phone, keyboardType: TextInputType.phone, decoration: sosField('Phone number')),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: SosColors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
              onPressed: () {
                final n = name.text.trim();
                final p = phone.text.trim();
                if (n.isEmpty || p.replaceAll(RegExp(r'\D'), '').length < 7) {
                  ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Enter a name and a valid phone number')));
                  return;
                }
                SosStore.instance.addContact(TrustedContact(name: n, phone: p));
                Navigator.pop(ctx);
              },
              child: Text('Save contact', style: SosText.body(14, color: Colors.white, weight: FontWeight.w700)),
            ),
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: SosStore.instance,
      builder: (context, _) {
        final list = SosStore.instance.contacts;
        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('CONTACTS', style: SosText.display(44)),
                IconButton.filled(
                  style: IconButton.styleFrom(backgroundColor: SosColors.red),
                  onPressed: () => _add(context),
                  icon: const Icon(Icons.add_rounded, color: Colors.white),
                  tooltip: 'Add contact',
                ),
              ]),
              const SizedBox(height: 6),
              Text('People who should know when you need help.', style: SosText.body(13, color: SosColors.muted)),
              const SizedBox(height: 20),
              if (list.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: SosColors.line)),
                  child: Column(children: [
                    const Icon(Icons.people_outline_rounded, size: 32, color: SosColors.muted),
                    const SizedBox(height: 10),
                    Text('No trusted contacts yet', style: SosText.body(14, weight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('Add someone who can be reached in an emergency.', textAlign: TextAlign.center, style: SosText.body(12.5, color: SosColors.muted)),
                  ]),
                ),
              for (final c in list)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Dismissible(
                    key: ValueKey('${c.name}|${c.phone}'),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => SosStore.instance.removeContact(c),
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(color: SosColors.red, borderRadius: BorderRadius.circular(16)),
                      child: const Icon(Icons.delete_outline, color: Colors.white),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: SosColors.line)),
                      child: Row(children: [
                        CircleAvatar(
                          backgroundColor: SosColors.red,
                          child: Text(c.name.characters.first.toUpperCase(), style: SosText.body(15, color: Colors.white, weight: FontWeight.w700)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(c.name, style: SosText.body(14, weight: FontWeight.w600)),
                            Text(c.phone, style: SosText.body(12, color: SosColors.muted)),
                          ]),
                        ),
                      ]),
                    ),
                  ),
                ),
              if (list.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text('Swipe left to remove a contact.', style: SosText.body(11.5, color: SosColors.muted)),
                ),
            ],
          ),
        );
      },
    );
  }
}
