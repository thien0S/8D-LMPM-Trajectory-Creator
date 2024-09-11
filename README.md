
+--------------------------------------------------------------------------------------------------------------------------------+
|  ___  ____    _     __  __ ____  __  __   _____           _           _                      ____                _             |
| ( _ )|  _ \  | |   |  \/  |  _ \|  \/  | |_   _| __ __ _ (_) ___  ___| |_ ___  _ __ _   _   / ___|_ __ ___  __ _| |_ ___  _ __ |
| / _ \| | | | | |   | |\/| | |_) | |\/| |   | || '__/ _` || |/ _ \/ __| __/ _ \| '__| | | | | |   | '__/ _ \/ _` | __/ _ \| '__||
|| (_) | |_| | | |___| |  | |  __/| |  | |   | || | | (_| || |  __/ (__| || (_) | |  | |_| | | |___| | |  __/ (_| | || (_) | |   |
| \___/|____/  |_____|_|  |_|_|   |_|  |_|   |_||_|  \__,_|/ |\___|\___|\__\___/|_|   \__, |  \____|_|  \___|\__,_|\__\___/|_|   |
|                                                        |__/                         |___/                                      |
+--------------------------------------------------------------------------------------------------------------------------------+





8D-LMPM-Trajectory-Creator est une application *Matlab* qui permet de créer des trajectoires pour un robot parallèle à 8 degrées de libertés.



## Utilisation

Pour utiliser l'application lancer le fichier (le système qui execute l'application doit détenir *Matlab* ainsi que la librairie *Simscape*):

```bash
LMPM_8D_Controller.mlapp
```



## Fonctionnement

```bash
GestionRedondance.m
```
Ce script permet d'automatiquement grâce à un alogrithme d'évitement de singularité de gérer les pattes redondantes du robot

---

```bash
runValidateModel.m
```
Ce script permet d'initialiser le modèle Simscape du robot pour venir simuler et effectuer une vérification visuelle de la trajectoire fraîchement créée
Le modèle du robot se trouve dans le dossier /8DOF_robotModel

---

```bash
exportTraj.m
```
Ce script permet d'exporter la trajectoire et de la sauvegarder dans la base de donnée *trajVar.mat* qui se trouve dans le dossier /pos_8mot





### Auteur

Ce projet à été réalisé par **Martin Leray** avec l'aide de Jonathan Lacombe

