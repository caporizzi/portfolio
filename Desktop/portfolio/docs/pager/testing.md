# Compétences

## Computer Science Engineering

### Analyser un problème

J’ai analysé les approches de génération de textures 3D à partir de modèles génératifs (text2texture vs image2texture) afin d’identifier leurs limites en termes de cohérence visuelle, contrôlabilité et adaptabilité au pipeline de production → [Rapport text2texture](https://toys-r-us-rex.github.io/Duckify/genai/t2t_recherche.pdf) et [Rapport image2texture](https://toys-r-us-rex.github.io/Duckify/genai/i2t_recherche.pdf)

J’ai analysé les contraintes liées à l’utilisation de modèles de diffusion (coût GPU), impactant directement la scalabilité du système → [Rapport analyse](https://toys-r-us-rex.github.io/Duckify/genai/computation.pdf)

J'ai analysé les limites de la méthode image2texture →  [Rapport Analyse](https://toys-r-us-rex.github.io/Duckify/genai/i2t_review.pdf)

### Concevoir une solution théorique modélisée

J'ai conçu une méthode de génération de textures basée sur image2texture [Rapport image2texture](https://github.com/caporizzi/portfolio/blob/main/Desktop/portfolio/papers/GenAI%20-%20paper.pdf)

### Implémenter une approche théorique modélisée

J'ai implémenté le benchmark automatisé pour l'évaluation de canard [Benchmark Live](https://github.com/Toys-R-Us-Rex/Duckify/pull/115)

J'ai implementé la génération des images multiview en vue d'un finetuning [bpy-renderer](https://github.com/Toys-R-Us-Rex/bpy-renderer/commits/0b83566dd2cec7cf08f5cd206df7b2f3fd8abeb7/)

J'ai implementé la génération de mesh texturé en vue d'un finetuning [Tencent/hunyuan3d-2](https://github.com/Toys-R-Us-Rex/Hunyuan)

J'ai implementé un modèle de diffusion on premise pour tester les limites de image2texture [Flux Kontext](https://github.com/Toys-R-Us-Rex/Flux_Image_generation)

### Evaluer un système informatique

Situation: Difficulté à évaluer objectivement les générations.

Action: Mise en place d’une évaluation humaine (qualité, contraintes, dessinabilité) et automatisée (similarité, esthétisme, validation).

Résultat: Plus de 200 générations évaluées de manière structurée.

[Vue d'ensemble](https://hessoit-my.sharepoint.com/:x:/g/personal/marco_caporizz_hes-so_ch/IQAMxPcL6RZaS6prJS5g077yASUoKq_Tkrwxr3mG06NbAR0?e=TwsbaX)

J’ai évalué plus de 200 générations afin d’identifier les paramètres optimaux et les limites du modèle 

## Data Engineering

### Valoriser des ensembles de données hétérogènes et multimodales

J'ai valorisé mes données de canard en visualisant le résultat du mesh texturé sous plusieurs vues en vue de l'évaluation automatisée [Fonction Render](https://github.com/Toys-R-Us-Rex/MV-Adapter/blob/main/scripts/benchmark/render_rw.py)

J'ai valorisé mes données de canard en créant un leaderboard de beauté basé sur les évaluations du benchmark [Fonction Rw](https://github.com/Toys-R-Us-Rex/MV-Adapter/blob/main/scripts/benchmark/rank_rw.py)

### Orchestrer un processus et une infrastructure de traitement de données

Situation: Limitation GPU (<16GB VRAM) pour les modèles de diffusion.

Action: Analyse des solutions, demande validée pour une infrastructure plus performante.

Résultat: Accès à des ressources adaptées et amélioration des performances.

[Infrastructure](https://github.com/caporizzi/portfolio/blob/main/Desktop/portfolio/papers/Calcul_AWS.pdf)

Situation: Besoin de standardiser la génération à grande échelle.

Action: Calibration des hyperparamètres et évaluation de leur impact.

Résultat: Identification des paramètres optimaux.

[Phase de calibrage](https://docs.google.com/spreadsheets/d/1YWFxIgh-5cxQ3ukn9E-Lol9VvpamSTk78wUWdIhKVwA/edit?usp=sharing)

### Appliquer les compétences de l’ingénierie en informatique au domaine des données

J'ai généré des scripts SLURM afin de générer des textures pendant la nuit [Script SLURM basique](https://github.com/Toys-R-Us-Rex/Duckify/blob/main/genai/run.slurm) 


## Professionalism

### Communiquer clairement et efficacement

J'ai rédigé des rapports des meetings journaliers [Daily02.03.2026](https://toys-r-us-rex.github.io/Duckify/meetings/daily/2026-03-02.pdf), [Daily16.03.2026](https://toys-r-us-rex.github.io/Duckify/meetings/daily/2026-03-16.pdf), [Daily26.03.2026](https://toys-r-us-rex.github.io/Duckify/meetings/daily/2026-03-26.pdf)

J'ai rédigé le procès-verbale de la réunion avec le client [Client03.03.2026](https://toys-r-us-rex.github.io/Duckify/meetings/ceo/pv-2026-03-03.pdf)

J'ai rédigé le rapport lors du meeting hebdomadaires avec le CTO[Weekly20.02.2026](https://toys-r-us-rex.github.io/Duckify/meetings/weekly/2026-02-20.pdf)

J'ai présenté mes contributions lors des meetings hebdomadaires avec le CTO [Semaine1](https://toys-r-us-rex.github.io/Duckify/presentations/20260220_duckify_meeting_week_1.pdf), [Semaine2](https://toys-r-us-rex.github.io/Duckify/presentations/20260227_duckify_meeting_week_2.pdf), [Semaine3](https://toys-r-us-rex.github.io/Duckify/presentations/20260306_duckify_meeting_week_3.pdf),  [Semaine4](https://toys-r-us-rex.github.io/Duckify/presentations/20260313_duckify_meeting_week_4.pdf),  [Semaine5](https://toys-r-us-rex.github.io/Duckify/presentations/20260320_duckify_meeting_week_5.pdf),  [Semaine6](https://toys-r-us-rex.github.io/Duckify/presentations/20260327_duckify_meeting_week_6.pdf)

### Adopter une posture professionnelle

J'ai montré du leadership lors du meeting du 25.03.2026 en tant que Scrum Master en mettant en évidence des points critiques telle que l'intégration, j'ai pris une décision et alloué des personnes [Daily Meeting 25032026](https://toys-r-us-rex.github.io/Duckify/meetings/daily/2026-03-25.pdf)

J'ai pris l'initiative de coordoner ce qui allait être montrer au client lors de la présentation en collaborant avec les équipes robot et tracing [Collaboration prés client](https://toys-r-us-rex.github.io/Duckify/planning/demonstration_ceo.pdf)

J'ai review des PR afin de faire avancer le projet [PR12](https://github.com/Toys-R-Us-Rex/Duckify/pull/12), [PR48](https://github.com/Toys-R-Us-Rex/Duckify/pull/48), [PR57](https://github.com/Toys-R-Us-Rex/Duckify/pull/57), [PR64](https://github.com/Toys-R-Us-Rex/Duckify/pull/64), [PR91](https://github.com/Toys-R-Us-Rex/Duckify/pull/91), [PR109](https://github.com/Toys-R-Us-Rex/Duckify/pull/115),[PR115](https://github.com/Toys-R-Us-Rex/Duckify/pull/115)

### Argumenter ses opinions et ses choix

J'ai argumenté l'adoption de la méthode image2texture et le rejet de text2texture en [rapport](https://toys-r-us-rex.github.io/Duckify/genai/genAI_t2t_vs_i2t.pdf) et lors du weekly meeting 4 pour atteindre la milestone [slide21](https://toys-r-us-rex.github.io/Duckify/presentations/20260313_duckify_meeting_week_4.pdf) 

J'ai communiqué mes choix pour l'intégration du benchmark ( scripts ) et aidé mon camarade qui a intégré dans la pipeline [Benchmark Live](https://github.com/Toys-R-Us-Rex/Duckify/pull/115)

### [Critiquer une production de manière auto-réflexive]

J'ai su recevoir une critique et j'ai jugé ma visualisation peu structuré pour une exploitation à grande echelle: j'adapte la visualisation des générations de canard [viz](https://toys-r-us-rex.github.io/Duckify/genai/historique_visualisation.pdf)