import 'package:flutter/material.dart';
import 'package:formation_flutter/model/rappel.dart';
import 'package:url_launcher/url_launcher.dart';

/// Écran de détail d'un rappel produit.
/// Reproduit l'interface des fiches PDF de Rappel Conso.
class RappelDetailScreen extends StatelessWidget {
  const RappelDetailScreen({super.key, required this.rappel});

  final Rappel rappel;

  static const _red = Color(0xFFA60000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _red,
        foregroundColor: Colors.white,
        title: const Text('Rappel produit'),
        actions: [
          if (rappel.lienPdf != null)
            IconButton(
              tooltip: 'Ouvrir la fiche PDF',
              icon: const Icon(Icons.picture_as_pdf_outlined),
              onPressed: () async {
                final uri = Uri.parse(rappel.lienPdf!);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Photo ──────────────────────────────────────────
            if (rappel.photoUrl != null)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    rappel.photoUrl!,
                    height: 180,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              ),

            const SizedBox(height: 16.0),

            // ── Nom & marque ───────────────────────────────────
            if (rappel.libelleProduit != null)
              Text(
                rappel.libelleProduit!.toUpperCase(),
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: _red,
                ),
              ),
            if (rappel.marque != null) ...[
              const SizedBox(height: 4.0),
              Text(
                rappel.marque!,
                style: const TextStyle(
                  fontSize: 15.0,
                  fontStyle: FontStyle.italic,
                  color: Colors.black54,
                ),
              ),
            ],

            const SizedBox(height: 16.0),
            const Divider(),

            // ── Dates de commercialisation ─────────────────────
            _Section(
              title: 'Dates de commercialisation',
              content: _datesContent(),
            ),

            // ── Distributeurs ──────────────────────────────────
            _Section(
              title: 'Distributeurs',
              content: rappel.distributeurs,
            ),

            // ── Zone géographique ──────────────────────────────
            _Section(
              title: 'Zone géographique concernée',
              content: rappel.zoneGeographique,
            ),

            // ── Motif du rappel ────────────────────────────────
            _Section(
              title: 'Motif du rappel',
              content: rappel.motifRappel,
              highlight: true,
            ),

            // ── Risques ────────────────────────────────────────
            _Section(
              title: 'Risques encourus',
              content: rappel.risquesEncouirus,
            ),

            // ── Conduite à tenir ───────────────────────────────
            _Section(
              title: 'Conduite à tenir',
              content: _conduiteFormatted(),
            ),

            // ── Informations complémentaires ───────────────────
            _Section(
              title: 'Informations complémentaires',
              content: rappel.informationsComplementaires,
            ),

            // ── Contact ────────────────────────────────────────
            if (rappel.numeroContact != null)
              _Section(
                title: 'Numéro de contact',
                content: rappel.numeroContact,
              ),

            // ── Modalités de compensation ──────────────────────
            _Section(
              title: 'Modalités de compensation',
              content: rappel.modalitesCompensation,
            ),

            const SizedBox(height: 32.0),
          ],
        ),
      ),
    );
  }

  String? _datesContent() {
    final debut = rappel.dateDebutCommercialisation;
    final fin = rappel.dateFinCommercialisation;
    if (debut == null && fin == null) return null;
    final parts = <String>[];
    if (debut != null) parts.add('Du $debut');
    if (fin != null) parts.add('au $fin');
    return parts.join(' ');
  }

  /// Transforme "a|b|c" en liste à puces.
  String? _conduiteFormatted() {
    final raw = rappel.conduiteATenir;
    if (raw == null) return null;
    return raw
        .split('|')
        .map((e) => '• ${e.trim()}')
        .where((e) => e.length > 2)
        .join('\n');
  }
}

// ── Widget section ──────────────────────────────────────────

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.content,
    this.highlight = false,
  });

  final String title;
  final String? content;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    if (content == null || content!.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFFA60000),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4.0),
          Container(
            width: double.infinity,
            padding: highlight
                ? const EdgeInsets.all(10.0)
                : EdgeInsets.zero,
            decoration: highlight
                ? BoxDecoration(
                    color: const Color(0xFFFF0000).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8.0),
                  )
                : null,
            child: Text(
              content!,
              style: const TextStyle(fontSize: 14.0, height: 1.5),
            ),
          ),
          const Divider(height: 24.0),
        ],
      ),
    );
  }
}