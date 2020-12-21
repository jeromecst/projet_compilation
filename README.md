### Auteurs :  
* Jérôme Coquisart
* Ursula Alcantara Hernandez

---

### Ce qui a été fait :

* Dans le **lexer**:
	* on a ajouté une ligne qui permet de reconnaitre les commentaires de la forme `//`
	* si un caractère n'est pas reconnu, la ligne et la position du caractère sont affichées, avec une erreur déclenchée

* Pour la **déclaration des variables**, on a étendu le type des déclarations de variables dans la syntaxe abstraite à `(string * typ * expr) list`
* Deux fonctions ne peuvent pas avoir le même nom, sinon cela déclenche une erreur (choix personnel)

* Dans le **parser** :
	* si il y a une erreur de syntaxe, la ligne et la position de l'erreur sont affichées
	* les variables prennent la valeur `Cst(0)` par défaut, si aucune autre valeur n'est précisée
	* tous les conflits on été résolus

* Dans **l'analyseur de types** :
	* on travaille avec 3 tables de hachage pour représenter l'environnement
		* les variables globales
		* les fonctions
		* une double table de hachage avec pour chaque fonction, une table de hachage avec la liste des variables locales
	* pour savoir dans quel fonction on se trouve, on utilise un `string` avec le nom de la fonction
	* s'il y a une erreur de type, un message d'erreur s'affiche avec le type impliqué dans l'erreur
	* on analyse toutes les expressions possibles, notamment les paramètres d'entrées des fonctions, les returns etc...

* Un **Makefile** a été créé, on peut y trouver
	* Les lignes de compilation avec `make`
	* Les fichiers à tester avec `make test`
	* Les fichiers qui vont générer des erreurs avec `make fail`
		* *il faudra commenter ou décommenter les fichiers à tester car sinon un seul fichier s'execute à la fois*
	* La suppression des fichiers de compilation avec `make clean`

