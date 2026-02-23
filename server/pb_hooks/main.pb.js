/// <reference path="../pb_data/types.d.ts" />

console.log("Chargement du hook de synchronisation des rappels…");
console.log("HOOK LOADED !");
console.log("typeof app =", typeof app);

// Planification toutes les 12 heures
app.tasks.schedule("sync_rappels", "0 */12 * * *", async () => {
    console.log("Début de la synchronisation des rappels…");

    try {
        // 1. Récupération des données API
        const response = await fetch("https://codelabs.formation-flutter.fr/assets/rappels.json");
        const data = await response.json();

        console.log(`${data.length} rappels récupérés depuis l’API.`);

        // 2. Parcours des rappels
        for (const item of data) {

            const mapped = {
                id_api: item.id,
                gtin: item.gtin,
                rappel_guid: item.rappel_guid,
                numero_fiche: item.numero_fiche,
                numero_version: item.numero_version,
                libelle: item.libelle,
                marque_produit: item.marque_produit,
                modeles_ou_references: item.modeles_ou_references,

                photo_url: item.liens_vers_les_images,
                date_debut_commercialisation: item.date_debut_commercialisation,
                date_fin_commercialisation: item.date_date_fin_commercialisation,
                distributeurs: item.distributeurs,
                zone_geographique: item.zone_geographique_de_vente,
                motif_rappel: item.motif_rappel,
                risques_encourus: item.risques_encourus,
                infos_complementaires: item.informations_complementaires_publiques || item.informations_complementaires,
                conduite_a_tenir: item.conduites_a_tenir_par_le_consommateur,
                pdf_url: item.lien_vers_affichette_pdf,
                date_publication: item.date_publication
            };

            // 3. Vérification si l'entrée existe déjà
            const existing = await app.db
                .select("*")
                .from("rappels")
                .where("id_api = {:id}", { id: item.id })
                .first();

            if (existing) {
                await app.db.update("rappels", existing.id, mapped);
                console.log(`Mise à jour du rappel ID ${item.id}`);
            } else {
                await app.db.insert("rappels", mapped);
                console.log(`Ajout du rappel ID ${item.id}`);
            }
        }

        console.log("Synchronisation terminée avec succès.");

    } catch (error) {
        console.error("Erreur lors de la synchronisation :", error);
    }
});
