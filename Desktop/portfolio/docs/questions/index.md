# Marco's self reflection

???+ note "Comment évaluer et benchmarker les textures générées pour le projet de canard 3D ?"

    Afin d’évaluer les performances des méthodes de génération de textures appliquées au modèle de canard 3D, un protocole de benchmark est mis en place à partir d’un jeu de textures de référence.

    L’évaluation combine des mesures quantitatives et qualitatives. Les mesures quantitatives incluent la similarité pixel par pixel avec la texture de référence, la précision de l’application sur la UV map, et la fidélité des couleurs. Les mesures qualitatives portent sur l’aspect visuel global, le respect du prompt du client et le réalisme perçu.

    Une partie de cette évaluation peut être automatisée à l’aide de modèles d’apprentissage automatique. Par exemple, NIMA (Neural Image Assessment) permet d’estimer la qualité esthétique d’une image, tandis que OpenCLIP mesure la similarité entre la texture générée et le prompt textuel.

    Ce pipeline de benchmark automatisé permet de comparer efficacement différentes approches algorithmiques et de sélectionner la méthode la plus performante pour générer des textures précises et visuellement cohérentes.

    [Compétences: création du benchmark]()

???+ note "Peux-tu expliquer les composants d’un modèle 3D et comment les UV maps et les textures interagissent dans Blender ?"

    Un modèle 3D est composé de plusieurs éléments principaux. La géométrie, formée de points (vertices), d’arêtes (edges) et de faces (faces), définit la forme du modèle. Les matériaux déterminent la manière dont la surface réagit à la lumière, en influençant par exemple la couleur, la brillance ou la transparence. Les textures sont des images 2D appliquées sur le modèle pour lui donner un aspect réaliste ou stylisé.

    Les UV maps sont des projections en deux dimensions de la surface du modèle 3D. Elles permettent de positionner correctement les textures sur la géométrie afin qu’elles suivent la forme des faces sans déformation.

    Dans Blender, le processus consiste généralement à créer la géométrie du modèle, puis à effectuer un UV unwrapping pour générer la UV map. Les textures sont ensuite appliquées sur cette UV map via les matériaux.
