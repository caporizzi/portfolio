???+ note "Je transforme mes données bruts en données exploitables"

    Situation: Je travaille sur un ensemble de données générés qui sont mes textures de canards. Ces données ne sont pas directement exploitable, pour une évaluation car elles sont représenté en 2D, alors que l'objectif implique une utilisation en 3D.

    Action: Je fais une trasformation de mes données, j'applique la texture à mon modèle de canard et je génère les vues utles à l'évaluation du rendu visuel. Je structure l'output de mon système afin qu'à chaque génération je possède la texture en .png, le modèl avec la texture appliquée en .glb, la multiview avec 6 view en .png, le rendu final avec 4 vues de face profil et les cotés en .png, et un json avec les metadata pour garder l'historique de mes générations.

    Résultat: J'ai produis un dataset multimodal structuré et standardisé. Cela permet une meilleur représentation des données et j'améliore la qualité de mon dataset.  