import 'package:flutter/material.dart';

class SeuilAlerte extends StatefulWidget {
  const SeuilAlerte({super.key});

  @override
  State<SeuilAlerte> createState() => _SeuilAlerteState();
}

class _SeuilAlerteState extends State<SeuilAlerte> {
  bool _showForm = false;

  // Données exemple (à remplacer par ta liste réelle depuis API/Firestore)
  final List<Map<String, dynamic>> seuils = [
    {
      'type': 'Pluie',
      'min': 0,
      'max': 10,
      'unite': 'mm',
      'duree': '7 jours',
      'culture': 'Maïs',
      'phase': 'Croissance',
      'zone': 'Sikasso',
      'niveau': 'critique',
      'statut': 'actif',
    },
    // ajoute d'autres si tu veux plus de lignes
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
     padding: const EdgeInsets.all(32),
  child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
    children: [
       Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
         const Text(
            'Gestion des seuils d\'alerte météo',
         style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ElevatedButton.icon(
             icon: const Icon(Icons.add),
            label: const Text('Ajouter seuil'),
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
               foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
             onPressed: () {
                setState(() => _showForm = true);
              },
            ),
         ],
       ),
    const SizedBox(height: 32),

       if (_showForm)
         _buildFormAjout()
       else
         _buildListeSeuils(),
      ],
      ),
    );
  }

  Widget _buildListeSeuils() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 24,
          headingRowColor: WidgetStatePropertyAll(const Color(0xFF10B981)),
          headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          columns: const [
            DataColumn(label: Text('Type météo')),
            DataColumn(label: Text('Min')),
            DataColumn(label: Text('Max')),
            DataColumn(label: Text('Unité')),
            DataColumn(label: Text('Durée')),
            DataColumn(label: Text('Culture')),
            DataColumn(label: Text('Phase')),
            DataColumn(label: Text('Zone')),
            DataColumn(label: Text('Niveau')),
            DataColumn(label: Text('Statut')),
            DataColumn(label: Text('Actions')),
          ],
          rows: seuils.map((seuil) {
            return DataRow(cells: [
              DataCell(Text(seuil['type'])),
              DataCell(Text(seuil['min'].toString())),
              DataCell(Text(seuil['max'].toString())),
              DataCell(Text(seuil['unite'])),
              DataCell(Text(seuil['duree'])),
              DataCell(Text(seuil['culture'])),
              DataCell(Text(seuil['phase'])),
              DataCell(Text(seuil['zone'])),
              DataCell(Text(seuil['niveau'])),
              DataCell(Text(seuil['statut'])),
              DataCell(
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    // TODO: confirmation + suppression
                    setState(() {
                      seuils.remove(seuil);
                    });
                  },
                ),
              ),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFormAjout() {
    String? selectedType = 'Pluie';
    String? selectedUnite = 'mm';
    String? selectedCulture;
    String? selectedPhase;
    String? selectedZone;
    String? selectedNiveau = 'Normal';
    String? selectedStatut = 'actif';

    final typesMeteo = ['Pluie', 'Température', 'Humidité', 'Vent'];
    final unites = ['mm', '°C', '%', 'km/h'];
    final cultures = ['Maïs', 'Mil', 'Riz', 'Sorgho', 'Coton'];
    final phases = ['Semis', 'Levée', 'Croissance', 'Floraison', 'Maturation'];
    final zones = ['Sikasso', 'Kayes', 'Koulikoro', 'Ségou', 'Mopti'];
    final niveaux = ['Normal', 'Attention', 'Alerte', 'Critique'];
    final statuts = ['actif', 'inactif'];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ajouter seuil',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),

            // Informations météorologiques
            const Text('Informations météorologiques', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Type météo', style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedType,
                        items: typesMeteo.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: (v) => setState(() => selectedType = v),
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Unité', style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedUnite,
                        items: unites.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                        onChanged: (v) => setState(() => selectedUnite = v),
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: '0',
                    decoration: const InputDecoration(
                      labelText: 'Valeur minimale',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    initialValue: '7 jours',
                    decoration: const InputDecoration(
                      labelText: 'Durée',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Contexte agricole
            const Text('Contexte agricole', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Culture', border: OutlineInputBorder()),
                    items: cultures.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (v) => selectedCulture = v,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Phase de culture', border: OutlineInputBorder()),
                    items: phases.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (v) => selectedPhase = v,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Zone', border: OutlineInputBorder()),
                    items: zones.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (v) => selectedZone = v,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Paramètre d'alerte
            const Text('Paramètre d\'alerte', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedNiveau,
                    decoration: const InputDecoration(labelText: 'Niveau d\'alerte', border: OutlineInputBorder()),
                    items: niveaux.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (v) => setState(() => selectedNiveau = v),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedStatut,
                    decoration: const InputDecoration(labelText: 'Statut', border: OutlineInputBorder()),
                    items: statuts.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (v) => setState(() => selectedStatut = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    setState(() => _showForm = false);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: const Text('Annuler'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    // TODO: sauvegarde réelle (API, Firestore, etc.)
                    setState(() {
                      _showForm = false;
                      // Ajouter à la liste si tu veux simuler
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  ),
                  child: const Text('Enregistrer'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}