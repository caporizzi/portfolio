???+ note "j’ai développé un processus permettant de produire et exploiter des textures de canards - Mobilisation des ressources computationnelles"

    Situation: Je suis confronté à une contraite computationnelle quand j'essaie de générer des canards avec des modèles de diffusion au dela de 16 GB VRAM

    Action: Je me renseigne sur le prix et l'utilisation d'un hardware plus puissant. Je fais une demande formelle au Product Owner et CTO. Le client accepte le trade-off pour avoir des canards avec un meilleur aspect visuel en echange d'une augmentation de budget pour avoir de meilleur performance.

    Résultat: Je résouds mes problèmes computationnelles, j'ai maintenant accès à des serveurs au dela de 16 GB de VRAM.

    [demande et utilisation d’infrastructures adaptées pour exécuter le modèle de diffusion](https://github.com/caporizzi/portfolio/blob/main/Desktop/portfolio/papers/Calcul_AWS.pdf)

???+ note "j’ai développé un processus permettant de produire et exploiter des textures de canards - Génération des données"

    Situation: Je suis confronté à un problème d'optimisation. Le meilleur modèle de génération a été décidé. Je peux maintenant générer une infinité de canard. Je dois le faire de manière standardisé.

    Action: Je passe à la phase de calibrage, je liste tous mes hyperparamêtres tel que le nombre d'inférence et la guidance. Je détermine avec une évaluation humaine quel hyperparametres influence le plus la qualité visuelle de mon canard.

    Résultat: Après avoir évaluer toutes les générations, je connais la valeur idéale de mes hyperparametres.

    [Phase de calibrage](https://docs.google.com/spreadsheets/d/1YWFxIgh-5cxQ3ukn9E-Lol9VvpamSTk78wUWdIhKVwA/edit?usp=sharing) 

