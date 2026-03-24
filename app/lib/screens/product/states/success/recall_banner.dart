import 'package:flutter/material.dart';
import 'package:formation_flutter/model/rappel.dart';
import 'package:formation_flutter/screens/rappel/rappel_detail_screen.dart';

/// Bandeau d'alerte affiché quand un rappel produit est détecté.
///
/// Spécifications :
///   - Fond    : #FF0000 à 36 % d'opacité
///   - Texte   : #A60000 à 100 %
///   - Arrondi : 12 px
///   - Marges  : 8 px horizontal / 12 px vertical
class RecallBanner extends StatelessWidget {
  const RecallBanner({super.key, required this.rappel});

  final Rappel rappel;

  static const _bgColor = Color(0xFFFF0000);
  static const _fgColor = Color(0xFFA60000);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RappelDetailScreen(rappel: rappel),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            color: _bgColor.withOpacity(0.36),
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 10.0,
          ),
          child: Row(
            children: [
              const Icon(Icons.warning_rounded, color: _fgColor),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '⚠️ Rappel produit',
                      style: TextStyle(
                        color: _fgColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                    if (rappel.motifRappel != null)
                      Text(
                        rappel.motifRappel!,
                        style: TextStyle(color: _fgColor, fontSize: 12.0),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: _fgColor),
            ],
          ),
        ),
      ),
    );
  }
}