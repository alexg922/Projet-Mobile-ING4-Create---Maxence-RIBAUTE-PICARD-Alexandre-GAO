import 'package:pocketbase/pocketbase.dart';

class Rappel {
  final String id;
  final String? libelleProduit;
  final String? marque;
  final String? identificationLots;
  final String? photoUrl;
  final String? dateDebutCommercialisation;
  final String? dateFinCommercialisation;
  final String? distributeurs;
  final String? zoneGeographique;
  final String? motifRappel;
  final String? risquesEncouirus;
  final String? informationsComplementaires;
  final String? conduiteATenir;
  final String? lienPdf;
  final String? numeroContact;
  final String? modalitesCompensation;

  const Rappel({
    required this.id,
    this.libelleProduit,
    this.marque,
    this.identificationLots,
    this.photoUrl,
    this.dateDebutCommercialisation,
    this.dateFinCommercialisation,
    this.distributeurs,
    this.zoneGeographique,
    this.motifRappel,
    this.risquesEncouirus,
    this.informationsComplementaires,
    this.conduiteATenir,
    this.lienPdf,
    this.numeroContact,
    this.modalitesCompensation,
  });

  factory Rappel.fromRecord(RecordModel r) {
    return Rappel(
      id: r.id,
      libelleProduit: r.getStringValue('libelle_produit').nullIfEmpty,
      marque: r.getStringValue('marque').nullIfEmpty,
      identificationLots: r.getStringValue('identification_lots').nullIfEmpty,
      photoUrl: r.getStringValue('photo_url').nullIfEmpty,
      dateDebutCommercialisation:
          r.getStringValue('date_debut_commercialisation').nullIfEmpty,
      dateFinCommercialisation:
          r.getStringValue('date_fin_commercialisation').nullIfEmpty,
      distributeurs: r.getStringValue('distributeurs').nullIfEmpty,
      zoneGeographique: r.getStringValue('zone_geographique').nullIfEmpty,
      motifRappel: r.getStringValue('motif_rappel').nullIfEmpty,
      risquesEncouirus: r.getStringValue('risques_encourus').nullIfEmpty,
      informationsComplementaires:
          r.getStringValue('informations_complementaires').nullIfEmpty,
      conduiteATenir: r.getStringValue('conduite_a_tenir').nullIfEmpty,
      lienPdf: r.getStringValue('lien_pdf').nullIfEmpty,
      numeroContact: r.getStringValue('numero_contact').nullIfEmpty,
      modalitesCompensation:
          r.getStringValue('modalites_compensation').nullIfEmpty,
    );
  }
}

extension _StringNullIfEmpty on String {
  String? get nullIfEmpty => isEmpty ? null : this;
}