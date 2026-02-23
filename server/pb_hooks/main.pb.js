// Route manuelle pour déclencher l'importation
routerAdd("GET", "/api/import-recalls", (c) => {
    try {
        const url = "https://codelabs.formation-flutter.fr/assets/rappels.json";

        // 1. Assurer que la collection existe
        let collection;
        try {
            collection = $app.findCollectionByNameOrId("recalls");
        } catch (e) {
            collection = new Collection({
                name: "recalls",
                type: "base",
                listRule: "",
                viewRule: "",
                fields: [
                    { name: "gtin", type: "text", required: true },
                    { name: "brand", type: "text" },
                    { name: "name", type: "text" },
                    { name: "reason", type: "text" },
                    { name: "risks", type: "text" },
                    { name: "imageUrl", type: "text" },
                    { name: "pdfUrl", type: "text" }
                ],
            });
            $app.save(collection);
        }

        // 2. Appel à l'API
        const response = $http.send({
            url: url,
            method: "GET",
        });

        if (response.statusCode !== 200) {
            return c.json(response.statusCode, { error: "Failed to fetch data from API" });
        }

        const recalls = JSON.parse(response.raw);

        // 3. Traitement
        let count = 0;
        recalls.forEach((data) => {
            if (!data.gtin) return;

            let record;
            const gtinStr = data.gtin.toString();
            try {
                record = $app.findFirstRecordByFilter("recalls", "gtin = {:gtin}", { gtin: gtinStr });
            } catch (e) {
                record = new Record(collection);
            }

            record.set("gtin", gtinStr);
            record.set("brand", (data.marque_produit || "").toString());
            record.set("name", (data.libelle || data.modeles_ou_references || "").toString());
            record.set("reason", (data.motif_rappel || "").toString());
            record.set("risks", (data.risques_encourus || "").toString());
            record.set("imageUrl", data.liens_vers_les_images ? data.liens_vers_les_images.split('|')[0] : "");
            record.set("pdfUrl", (data.lien_vers_affichette_pdf || "").toString());

            $app.save(record);
            count++;
        });

        return c.json(200, { message: "Import success", count: count });
    } catch (e) {
        return c.json(500, { error: e.toString() });
    }
});

// Cron job 2x par jour (00:00 et 12:00)
cronAdd("import_recalls", "0 0,12 * * *", () => {
    try {
        const url = "https://codelabs.formation-flutter.fr/assets/rappels.json";
        const response = $http.send({
            url: url,
            method: "GET",
        });

        if (response.statusCode === 200) {
            const recalls = JSON.parse(response.raw);
            const collection = $app.findCollectionByNameOrId("recalls");

            recalls.forEach((data) => {
                if (!data.gtin) return;
                let record;
                try {
                    record = $app.findFirstRecordByFilter("recalls", "gtin = {:gtin}", { gtin: data.gtin.toString() });
                } catch (e) {
                    record = new Record(collection);
                }
                record.set("gtin", data.gtin.toString());
                record.set("brand", (data.marque_produit || "").toString());
                record.set("name", (data.libelle || data.modeles_ou_references || "").toString());
                record.set("reason", (data.motif_rappel || "").toString());
                record.set("risks", (data.risques_encourus || "").toString());
                record.set("imageUrl", data.liens_vers_les_images ? data.liens_vers_les_images.split('|')[0] : "");
                record.set("pdfUrl", (data.lien_vers_affichette_pdf || "").toString());
                $app.save(record);
            });
            console.log("CRON Import success (2x/day)");
        } else {
            console.error("CRON Import failed with status: " + response.statusCode);
        }
    } catch (e) {
        console.error("CRON Import error: " + e);
    }
});
