# Marco's self reflection

??? note "Comment benchmarker les textures générées ?"

    J’ai mis en place un benchmark.

    J’évalue avec :
    - métriques quantitatives (similarité pixel, UV, couleurs)
    - métriques qualitatives (visuel, respect du prompt)

    J’utilise :
    - NIMA → qualité esthétique
    - OpenCLIP → similarité prompt

    Le pipeline permet de comparer les modèles et sélectionner le meilleur.

---

??? note "Comment fonctionnent les UV maps et textures ?"

    Un modèle 3D contient :
    - géométrie (vertices, faces)
    - matériaux
    - textures

    La UV map projette le mesh en 2D.

    Elle permet d’appliquer une texture correctement sur la surface.

    Dans Blender :
    - unwrap du mesh
    - application de la texture via les matériaux

---

??? note "Quel workflow IA pour générer un canard ?"

    Deux approches :

    *Text-to-Texture*
    - prompt texte → texture → mesh

    *Image-to-Texture*
    - prompt → image → sélection → texture → mesh

    Image2Texture est plus contrôlable côté client.

---

??? note "Comment as-tu anticipé les besoins techniques ?"

    J’étais en début de pipeline (GenAI).

    Objectif : trouver rapidement une solution fonctionnelle.

    J’ai testé :
    - text2texture
    - image2texture

    Résultat : solution fonctionnelle semaine 2.

    Limite :
    j’aurais dû valider plus tôt avec CTO/PO.

    Anticipation réussie :
    - accès DACHA demandé tôt
    - début intégration semaine 2

??? note "Quelle perte de temps s’est révélée utile ?"

    Travail sur les UV maps dans Blender.

    Objectif : réduire les îlots UV.

    Résultat direct faible.

    Mais :
    - meilleure compréhension du UV mapping
    - amélioration de l’intégration

    Utile pour la team tracing (stabilité des textures).

??? note "Quelle difficulté t’a fait progresser ?"

    Bug → j’ai pensé à un problème local.

    J’ai tout debug / rebuild.

    Cause réelle : service externe (Calypso).

    Apprentissage :
    - vérifier d’abord les services externes
    - améliorer Git / gestion d’environnement

??? note "Comment rendre le pipeline scalable ?"

    J’ai structuré un pipeline :

    génération → dataset → évaluation

    J’ai défini :
    - prompts
    - paramètres
    - modèles

    J’utilise :
    - batch sur serveurs
    - stockage avec metadata

    Évaluation :
    - manuelle (début)
    - automatisée (NIMA, modèles)

    Objectif : générer et filtrer des milliers de designs.


---

??? note "Comment as-tu géré beaucoup de générations ?"

    Problème : limite machine locale.

    Solution :
    - demande de budget compute
    - utilisation de ressources externes

    Organisation :
    - textures en .png
    - versioning avec Git LFS
    - metadata (prompt, paramètres, modèle)

    Résultat :
    - suivi clair
    - reproductibilité des tests

??? note "Pourquoi certains artefacts apparaissent après projection sur le mesh ?"

    Les artefacts viennent de plusieurs sources.

    Premièrement, la UV map déforme certaines zones du mesh.
    → compression / étirement → formes cassées.

    Deuxièmement, le modèle génère une image 2D sans vraie connaissance 3D.
    → mauvaise correspondance avec la géométrie.

    Troisièmement, le background de l’image peut être projeté sur le mesh.
    → fuite de couleurs non souhaitées.

    Enfin, les zones non visibles doivent être “inventées”.
    → incohérences entre les vues.

    Résultat :
    perte de cohérence et artefacts visibles en multiview.

---

??? note "Pourquoi automatiser le benchmark est important ?"

    Le volume de données devient vite trop grand.

    Une évaluation manuelle :
    - prend du temps
    - n’est pas scalable
    - manque de reproductibilité

    L’automatisation permet :
    - d’évaluer des centaines de générations
    - de comparer les modèles de manière objective
    - de suivre les performances dans le temps

    Elle permet aussi d’identifier rapidement :
    - les bons résultats
    - les cas d’échec

    Résultat :
    gain de temps + meilleure prise de décision.

---

??? note "Comment générer des milliers de textures de manière scalable ?"

    Il faut structurer toute la pipeline.

    Étape 1 :
    définir un protocole (prompts, paramètres, modèles).

    Étape 2 :
    lancer les générations en batch sur serveurs (GPU).

    Étape 3 :
    stocker les résultats avec metadata :
    - prompt
    - paramètres
    - modèle

    Étape 4 :
    automatiser l’évaluation (benchmark).

    Étape 5 :
    filtrer et sélectionner les meilleurs résultats.

    Le tout doit être reproductible et automatisé.

    Résultat :
    génération massive, contrôlée et exploitable.

---