# ProjetSuggestionFilms
Projet d'architecture et microservice d'ING3 ICC 2023/2024

## Groupe
- Biscorray Alexandre,
- Kamgaing Rodrigue,
- Klein Arthur,
- Vacossin Antoine.

## Démarrage
``` bash
docker-compose up --build
```
L'application démarre à localhost:3000

## Fonctionnemement de la partie IA
- Collecte des notes des différents films pour les utilisateurs du groupe,
- Calcul d'une note moyenne par genre pour chaque utilisateur du groupe,
- La note du groupe pour un genre est la moyenne des notes individuelles (2 si
  non renseigné),
- Collecte des films les plus populaires (a du être changé par les 128 films
  les plus populaires pour la recherche 't'),
- La note pour le film est la moyenne des notees des genres présents (2 si non
  renseigné),
- Tri par note et affichage.

## Exemple d'utilisatoin
D'un premier lancement:
- Cliquer sur le bouton flottant en bas à droite,
- Cliquer sur le bouton pour créer un compte,
- Saisir les champs my_user, test@user.com, tE5!tE5!, tE5!tE5!,
- Valider la création du compte,
- Cliquer sur l'icône de recherche dans la barre du bas,
- Saisir le mot matrix dans la barre de recherche en haut,
- Quand la recherche s'est terminée, cliquer sur le premier film,
- Cliquer sur le bouton pour indiquer que l'on a vu le film,
- Cliquer sur le bouton et choisir une note,
- Valider le formulaire: l'icône d'oeil sur la page du film indiquera que le
  film a été vu,
- Créer un groupe via le dernier icône de la barre du bas,
- Cliquer sur le premier icône de la barre du bas et constater que les genres
  présents correspondent aux genres des films bien notés.

## Known issue

### Loading time
Le temps de réponse d'IMDb est très élevé ce qui rend la recherche de films et
la génération de recommendation très lente.

### Memory requirements
L'application peut échouer lors de son lancement ou au cours d'une opération si
l'hôte n'a pas assez d'espace disque,

### Port usage
L'application ne pourra pas se lancer si le port 3000 ou 8000 de l'hôte est
occupé (configurable dans le docker-compose.yaml).

### IMDb Connection
La connexion avec IMDb peut être problématiques dû:
- Au fait que certains champs ne soient pas toujours remplis pour la plupart
  des films (nottament director) sur IMDb,
- Au fait qu'IMDb envoit des erreurs internes pendant certaines erreurs de la
  journée si questionné.
