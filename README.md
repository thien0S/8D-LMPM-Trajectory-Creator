
# 8D LMPM Trajectory Creator

8D-LMPM-Trajectory-Creator est une application *Matlab* qui permet de créer des trajectoires pour un robot parallèle à 8 degrés de libertés.



## Utilisation

Pour utiliser l'application, lancer le fichier (le système qui exécute l'application doit détenir *Matlab* ainsi que la librairie *Simscape*):

```bash
LMPM_8D_Controller.mlapp
```



## Fonctionnement

```bash
GestionRedondance.m
```
Ce script permet d'automatiquement gérer les pattes redondantes du robot grâce à un algorithme d'évitement de singularités

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

Ce projet a été réalisé par **Martin Leray** avec l'aide de Jonathan Lacombe

