import 'package:flutter/material.dart';

class Parametres extends StatefulWidget {
  const Parametres({super.key});

  @override
  State<Parametres> createState() => _ParametresScreenState();
}

class _ParametresScreenState extends State<Parametres> {
  String langue = 'Français';
  String fuseau = 'GMT +0 (Mali)';
  String dureeDefaut = '7 jours';
  String niveauDefaut = 'Vigilance';
  String sourceMeteo = 'Open - Météo';
  bool notificationsActives = true;

  final langues = ['Français', 'Bambara', 'Anglais'];
  final fuseaux = ['GMT +0 (Mali)', 'GMT +1', 'GMT -5'];
  final durees = ['3 jours', '7 jours', '14 jours', '30 jours'];
  final niveaux = ['Normal', 'Vigilance', 'Alerte', 'Critique'];
  final sources = ['Open - Météo', 'Météo Mali', 'WeatherAPI', 'Autre'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
     padding: const EdgeInsets.all(32),
  child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
    children: [
     const Text(
         'Paramètres',
      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
     const SizedBox(height: 32),

        // Paramètres généraux
       _buildSectionCard(
         title: 'Paramètres généraux',
       child: Column(
         children: [
             Row(
             children: [
               Expanded(
                 child: DropdownButtonFormField<String>(
                    value: langue,
                   decoration: const InputDecoration(labelText: 'Langue par défaut'),
                   items: langues.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                   onChanged: (v) => setState(() => langue = v!),
                   ),
                 ),
              const SizedBox(width: 24),
               Expanded(
                 child: DropdownButtonFormField<String>(
                    value: fuseau,
                   decoration: const InputDecoration(labelText: 'Fuseau horaire'),
                    items: fuseaux.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                   onChanged: (v) => setState(() => fuseau = v!),
                   ),
                 ),
               ],
             ),
           ],
         ),
       ),

     const SizedBox(height: 32),

        // Gestion des seuils d'alerte
       _buildSectionCard(
         title: 'Gestion des seuils d\'alerte',
       child: Row(
         children: [
           Expanded(
             child: DropdownButtonFormField<String>(
                value: dureeDefaut,
               decoration: const InputDecoration(labelText: 'Durée par défaut d\'un seuil'),
               items: durees.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => setState(() => dureeDefaut = v!),
               ),
             ),
           const SizedBox(width: 24),
            Expanded(
             child: DropdownButtonFormField<String>(
                value: niveauDefaut,
               decoration: const InputDecoration(labelText: 'Niveau d\'alerte par défaut'),
               items: niveaux.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => setState(() => niveauDefaut = v!),
               ),
             ),
           ],
         ),
       ),

     const SizedBox(height: 32),

        // Données météo et IA
       _buildSectionCard(
         title: 'Données météo et IA',
       child: Row(
         children: [
           Expanded(
             child: DropdownButtonFormField<String>(
                value: sourceMeteo,
               decoration: const InputDecoration(labelText: 'Source météo'),
               items: sources.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => setState(() => sourceMeteo = v!),
               ),
             ),
           const SizedBox(width: 40),
             Row(
             children: [
               const Text('Notifications', style: TextStyle(fontSize: 16)),
               const SizedBox(width: 16),
                 Switch(
                  value: notificationsActives,
                 activeColor: const Color(0xFF10B981),
                 onChanged: (v) => setState(() => notificationsActives = v),
                 ),
               ],
             ),
           ],
         ),
       ),
      ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Card(
     elevation: 3,
     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
   child: Padding(
       padding: const EdgeInsets.all(24.0),
     child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF10B981))),
       const SizedBox(height: 16),
        child,
       ],
      ),
     ),
   );
  }
}
