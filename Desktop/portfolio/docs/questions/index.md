# Marco's self reflection

??? note "Comment évaluer et benchmarker les textures générées pour le projet de canard 3D ?"

    Afin d’évaluer les performances des méthodes de génération de textures appliquées au modèle de canard 3D, un protocole de benchmark est mis en place à partir d’un jeu de textures de référence.

    L’évaluation combine des mesures quantitatives et qualitatives. Les mesures quantitatives incluent la similarité pixel par pixel avec la texture de référence, la précision de l’application sur la UV map, et la fidélité des couleurs. Les mesures qualitatives portent sur l’aspect visuel global, le respect du prompt du client et le réalisme perçu.

    Une partie de cette évaluation peut être automatisée à l’aide de modèles d’apprentissage automatique. Par exemple, NIMA (Neural Image Assessment) permet d’estimer la qualité esthétique d’une image, tandis que OpenCLIP mesure la similarité entre la texture générée et le prompt textuel.

    Ce pipeline de benchmark automatisé permet de comparer efficacement différentes approches algorithmiques et de sélectionner la méthode la plus performante pour générer des textures précises et visuellement cohérentes.

    [Compétences: création du benchmark]()

??? note "Peux-tu expliquer les composants d’un modèle 3D et comment les UV maps et les textures interagissent dans Blender ?"

    Un modèle 3D est composé de plusieurs éléments principaux. La géométrie, formée de points (vertices), d’arêtes (edges) et de faces (faces), définit la forme du modèle. Les matériaux déterminent la manière dont la surface réagit à la lumière, en influençant par exemple la couleur, la brillance ou la transparence. Les textures sont des images 2D appliquées sur le modèle pour lui donner un aspect réaliste ou stylisé.

    Les UV maps sont des projections en deux dimensions de la surface du modèle 3D. Elles permettent de positionner correctement les textures sur la géométrie afin qu’elles suivent la forme des faces sans déformation.

    Dans Blender, le processus consiste généralement à créer la géométrie du modèle, puis à effectuer un UV unwrapping pour générer la UV map. Les textures sont ensuite appliquées sur cette UV map via les matériaux.

??? note "Décris un workflow que tu utiliserais pour générer un design de canard au client en utilisant des techniques d’IA "

    Un workflow basé sur l’IA peut être utilisé pour générer automatiquement des designs de canards à partir des préférences du client.

    La première approche est le Text-to-Texture. Le client décrit le design souhaité à l’aide d’un texte. Un modèle de génération produit ensuite une texture correspondant à cette description. Cette texture est appliquée au modèle 3D via la UV map, ce qui permet ensuite au bras robotisé de peindre le canard.

    La seconde approche est le Image-to-Texture. À partir d’un prompt textuel, un modèle de génération d’images produit plusieurs propositions de design. Le client sélectionne celle qu’il préfère, puis l’image choisie est convertie en texture et appliquée sur le modèle 3D. Cette méthode permet d’impliquer davantage le client tout en automatisant la création du design.

    [Compétences: recherche de solution]()

??? note "Comment as-tu contribué à la planification et à l’anticipation des besoins techniques dans les premières semaines du projet ?"

    Au cours des deux premières semaines du projet, mon rôle a été fortement influencé par ma position au début du pipeline d’intégration, dans la partie GenAI. Cette position m’a amené à consacrer davantage de temps à l’exploitation de solutions existantes qu’à l’exploration approfondie de nouvelles approches.

    Mon objectif était d’identifier rapidement deux modèles différents capables de produire des résultats acceptables afin d’assurer une base fonctionnelle pour la suite du projet. Finalement, je me suis orienté vers des modèles capables de générer directement des textures, soit à partir de texte (Text-to-Texture), soit à partir d’images (Image-to-Texture). Cette approche m’a permis d’obtenir une solution fonctionnelle dès la fin de la semaine 2, même en l’absence d’un engagement clair du CEO sur la direction à suivre.

    Avec le recul, j’aurais toutefois pu valider plus tôt la qualité des textures auprès du PO ou du CTO avant le weekly meeting, afin de confirmer si les résultats étaient réellement suffisants, ce qui n’était finalement pas le cas.

    Par ailleurs, l’équipe GenAI a bien anticipé certains besoins techniques du projet. Par exemple, la demande d’accès à DACHA a été faite dès le vendredi de la semaine 1 auprès de Marc Pignat, ce qui a permis d’obtenir les accès dès le mercredi de la semaine 2. L’utilisation de cette infrastructure devait être envisagée après validation du CEO, mais le premier meeting n’a pas permis d’avancer dans cette direction.

    Enfin, l’équipe GenAI a également commencé l’intégration technique dès le jeudi de la semaine 2, afin de se rapprocher du milestone de la semaine 3 : obtenir un dessin automatiquement appliqué sur un canard. Cette anticipation et cette planification ont permis de maintenir le projet sur une trajectoire cohérente malgré certaines incertitudes décisionnelles.

??? note "Quelle activité qui semblait initialement être une perte de temps s’est finalement révélée utile pour le projet ?"

    Une activité qui pouvait initialement sembler être une perte de temps a été le travail approfondi sur les UV maps du mesh de canard dans Blender. J’ai passé plusieurs heures à manipuler et à optimiser le dépliage des UV. Mon raisonnement était que réduire le nombre d’îlots UV permettrait d’obtenir une texture plus cohérente et plus facile à évaluer par les modèles de génération.

    Même si cette approche n’a pas produit de résultats immédiatement concluants, ce travail m’a permis de mieux comprendre le processus de découpage UV manuel, ce qui s’est révélé utile pour la suite du projet.

    De plus, cette étape constituait une partie importante de l’intégration, car une UV map propre et stable permet de garantir la reproductibilité des textures appliquées sur le modèle. Cela est particulièrement important pour l’équipe de tracing, qui dépend d’une correspondance fiable entre la texture générée et la surface du modèle 3D.

??? note "Quelle difficulté technique t’a permis d’identifier des points d’amélioration dans tes méthodes de travail ?"

    Lors de tests de génération sur différents modèles, des erreurs sont apparues alors que l’environnement fonctionnait correctement la veille. Après plusieurs tentatives de debugging, j’ai reconfiguré l’environnement local et reconstruit une partie du projet afin d’identifier l’origine du problème.

    Il est apparu par la suite que la cause provenait d’une indisponibilité temporaire du service Calypso, et non d’un problème local. Cette situation a mis en évidence l’importance de vérifier en priorité la disponibilité des services externes lors du diagnostic.

    Elle m’a également permis d’identifier certaines lacunes dans ma maîtrise des workflows Git, notamment dans la gestion des modifications et la restauration rapide d’un environnement de travail stable. Cela m’a conduit à améliorer mes pratiques de versioning et de diagnostic technique.

??? note "Comment mettrais-tu en place un système scalable pour générer et évaluer un grand nombre de designs de canards ?"

    Pour passer de quelques centaines à plusieurs milliers de canards générés, il est nécessaire de mettre en place un pipeline de génération structuré et scalable.

    La première étape consiste à standardiser le processus de génération. Cela implique de définir des protocoles clairs, incluant les prompts utilisés, les paramètres de génération (par exemple le guidance scale ou le nombre d’inference steps), ainsi que les modèles employés. Les générations peuvent ensuite être lancées en batch sur des serveurs externes, ce qui permet de dépasser les limitations computationnelles des machines locales.

    Toutes les générations sont ensuite centralisées dans un dataset structuré. Chaque texture générée est enregistrée avec ses métadonnées, telles que le prompt utilisé, les paramètres de génération et le modèle employé. Ces informations peuvent être suivies dans un tableau de gestion des données, par exemple sous forme de fichier Excel, afin de faciliter l’analyse et le suivi des expérimentations.

    Une phase d’évaluation de la qualité est ensuite nécessaire. Dans un premier temps, les textures générées peuvent être évaluées manuellement selon plusieurs critères, tels que la qualité visuelle, le respect du prompt et la cohérence esthétique.

    Lorsque le volume de générations devient trop important pour une évaluation manuelle, il est possible d’introduire des méthodes automatisées. Par exemple, un modèle d’évaluation esthétique comme NIMA (Neural Image Assessment) peut être utilisé, ou bien un modèle interne peut être entraîné à partir des données déjà évaluées.

    Enfin, l’ensemble des étapes — génération, stockage, évaluation et filtrage — peut être intégré dans un pipeline automatisé. L’objectif est de produire, analyser et sélectionner des milliers de designs de canards de manière scalable, reproductible et efficace.

    [Competences: Data Engineer Collecte et traitement des données]()

??? note "Comment as-tu organisé la génération et le suivi d’un grand volume de textures générées par IA ?"

    L’objectif est de générer un grand volume de textures afin d’améliorer la qualité globale des résultats et de faciliter leur évaluation.

    La première contrainte rencontrée concernait les limites computationnelles de ma machine locale lors des phases de génération. Pour y répondre, une demande formelle d’augmentation du budget GenAI a été adressée au CEO afin de pouvoir utiliser davantage de ressources de calcul externes.

    En parallèle, un protocole de génération structuré a été mis en place afin d’organiser et de répertorier toutes les productions. Chaque génération produit une texture au format .png, qui est ensuite versionnée à l’aide de Git LFS afin de gérer efficacement les fichiers binaires volumineux.

    Chaque texture générée est également trackée avec ses métadonnées, notamment le prompt utilisé, les paramètres de génération (par exemple le guidance scale ou le nombre d’inference steps), ainsi que les paramètres du modèle employé. Cette organisation permet de faciliter l’analyse des résultats et la reproductibilité des expériences.

