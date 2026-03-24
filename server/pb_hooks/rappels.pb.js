/// <reference path="../pb_data/types.d.ts" />

onBootstrap(function (e) {
  e.next(); 

  // Orga de la collection


  var FIELDS = [
    { name: "libelle_produit",               type: "text" },
    { name: "marque",                        type: "text" },
    { name: "identification_lots",           type: "text" },
    { name: "photo_url",                     type: "text" },
    { name: "date_debut_commercialisation",  type: "text" },
    { name: "date_fin_commercialisation",    type: "text" },
    { name: "distributeurs",                 type: "text" },
    { name: "zone_geographique",             type: "text" },
    { name: "motif_rappel",                  type: "text" },
    { name: "risques_encourus",              type: "text" },
    { name: "informations_complementaires",  type: "text" },
    { name: "conduite_a_tenir",              type: "text" },
    { name: "lien_pdf",                      type: "text" },
    { name: "numero_contact",                type: "text" },
    { name: "modalites_compensation",        type: "text" },
  ];

  // Création de la collection si elle n'existe pas


  var collection;

  try {
    collection = $app.findCollectionByNameOrId("rappels");
    console.log("[rappels] Collection déjà existante ✅");
  } catch (_) {
    console.log("[rappels] Création de la collection…");

    collection = new Collection({
      name: "rappels",
      type: "base",
      fields: FIELDS,
    });

    $app.save(collection);
    console.log("[rappels] Collection créée ✅");
  }

// Fonction insert ou update si existant

  function upsertItems(col, items) {
    var created = 0;
    var updated = 0;

    for (var i = 0; i < items.length; i++) {
      var item = items[i];

      if (!item.identification_lots) continue;

      var lots     = item.identification_lots.replace(/'/g, "\\'");
      var existing = null;

      try {
        existing = $app.findFirstRecordByFilter(
          "rappels",
          "identification_lots = '" + lots + "'"
        );
      } catch (_) {}

      if (existing) {
        for (var f = 0; f < FIELDS.length; f++) {
          var fname = FIELDS[f].name;
          existing.set(fname, item[fname] !== undefined ? item[fname] : null);
        }
        $app.save(existing);
        updated++;
      } else {
        var record = new Record(col);
        for (var f = 0; f < FIELDS.length; f++) {
          var fname = FIELDS[f].name;
          record.set(fname, item[fname] !== undefined ? item[fname] : null);
        }
        $app.save(record);
        created++;
      }
    }

    console.log("[rappels] " + created + " créés, " + updated + " mis à jour");
  }

  // Import de rappels.json

  try {
    console.log("[rappels] Import rappels.json local…");
    var raw   = toString($os.readFile("./rappels.json"));
    var items = JSON.parse(raw);
    upsertItems(collection, items);
  } catch (err) {
    console.error("[rappels] Erreur import JSON local :", err);
  }

  //Fin du 4 appel 2 fois par jour

  cronAdd("sync_rappels", "0 0,12 * * *", function () {
    console.log("[rappels] ⏰ CRON déclenché — sync API Rappel Conso");

    try {
      var col = $app.findCollectionByNameOrId("rappels");

      var res = $http.send({
        url: "https://data.rappel.conso.gouv.fr/api/warning/public?search=&offset=0&limit=500",
        method: "GET",
      });

      if (res.statusCode !== 200) {
        console.error("[rappels] API status :", res.statusCode);
        return;
      }

      var body  = JSON.parse(res.rawBody);
      var items = Array.isArray(body) ? body : (body.data || []);

      if (!items.length) {
        console.log("[rappels] Aucun item reçu de l'API");
        return;
      }

      var mapped = items.map(function (r) {
        return {
          libelle_produit:              r.libelle_produit              || r.nomProduit                        || null,
          marque:                       r.marque                       || r.marque_produit                    || null,
          identification_lots:          r.identification_lots          || r.lot                               || null,
          photo_url:                    r.photo_url                    || r.lienVersPhoto                     || null,
          date_debut_commercialisation: r.date_debut_commercialisation || r.dateDebutCommercialisationProduit || null,
          date_fin_commercialisation:   r.date_fin_commercialisation   || r.dateFinCommercialisationProduit   || null,
          distributeurs:                r.distributeurs                || r.distributeur                      || null,
          zone_geographique:            r.zone_geographique            || r.zoneGeographique                  || null,
          motif_rappel:                 r.motif_rappel                 || r.motifRappel                       || null,
          risques_encourus:             r.risques_encourus             || r.risquesEncourusPourLeConsommateur || null,
          informations_complementaires: r.informations_complementaires || r.informationComplementaire         || null,
          conduite_a_tenir:             r.conduite_a_tenir             || r.conduiteATenir                    || null,
          lien_pdf:                     r.lien_pdf                     || r.lienVersFichePdf                  || null,
          numero_contact:               r.numero_contact               || r.numeroContact                     || null,
          modalites_compensation:       r.modalites_compensation       || r.modaliteDeCompensation            || null,
        };
      });

      upsertItems(col, mapped);
    } catch (err) {
      console.error("[rappels] Erreur CRON :", err);
    }
  });

  console.log("[rappels] ✅ Hook chargé — CRON actif (0h et 12h)");
});