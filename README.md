# Documentor

Documentor est un petit outil Pharo qui **produit un rapport sur une classe** sous forme de document Microdown.

Le rapport est généré avec `MicMicrodownTextualBuilder`. L'outil ne concatène jamais de chaînes de caractères pour mettre en forme sa sortie : chaque titre, paragraphe, élément de liste et mise en valeur passe par le builder.

Le projet est construit en TDD (tests d'abord), par versions :

| Version | Contenu | Statut |
|---|---|---|
| 1 | Nom de la classe, superclasse, champs, package | Terminée |
| 2 | Premier paragraphe du commentaire de classe, position dans la hiérarchie, méthodes avec leur premier commentaire | Terminée |
| 3 | Métriques (profondeur d'héritage, nombre de champs et de méthodes, appels à `super`, méthodes longues) | Terminée |
| 4 | Mini linter basé sur un visiteur | Pas commencée |

## Prérequis

- Une image Pharo récente. Microdown est fourni avec, il n'y a rien à installer.
- Le code utilise les classes d'AST `OC*` (`OCVariableNode`, ...) et `MicrodownParser`. Si votre image utilise d'autres noms, adaptez les méthodes concernées (voir [Limites connues](#limites-connues)).

## Installation

1. Clonez le dépôt avec Iceberg (ou ajoutez-le depuis le navigateur Iceberg).
2. Vérifiez que les packages `Documentor` et `Documentor-Tests` sont chargés dans l'image.
3. Lancez les tests (voir [Lancer les tests](#lancer-les-tests)).

## Les packages

### `Documentor` (le code)

| Classe | Rôle |
|---|---|
| `Documentor` | Point d'entrée. Contient la classe cible et un unique `MicMicrodownTextualBuilder`. Chaque méthode `report...` écrit une section dans ce builder. |
| `ClassMetrics` | Calcule les chiffres de la version 3. Elle renvoie des nombres et des collections simples et ne connaît rien de Microdown, ce qui la rend facile à tester. |
| `DocMethod` | Petite classe utilitaire qui extrait le premier commentaire d'une méthode compilée. |

La règle de conception est **calculer d'un côté, présenter de l'autre** : `ClassMetrics` et `DocMethod` produisent des données, et `Documentor` est la seule classe qui les transforme en appels au builder.

### `Documentor-Tests` (les tests et les fixtures)

| Classe | Rôle |
|---|---|
| `DocFakeAnimal` | Fixture. Champs `name` et `age`. Un commentaire de classe en deux paragraphes. Méthodes `age` (sans commentaire), `describe` et `name` (avec commentaire). |
| `DocFakeDog` | Fixture, sous-classe de `DocFakeAnimal`. Champ `breed`. Méthodes `bark`, `describe` (redéfinit et envoie `super`) et `longMethod` (une méthode volontairement longue). |
| `DocumentorTest` | Tests du contenu du rapport (versions 1 et 2, plus la présence de la section métriques). |
| `ClassMetricsTest` | Tests des métriques de la version 3. |

Les tests s'exécutent sur des classes fixtures que vous contrôlez, plutôt que sur des classes comme `OrderedCollection` qui peuvent changer d'une version de Pharo à l'autre.

## Utilisation

### Générer un rapport

```smalltalk
(Documentor on: DocFakeDog) report.
```

`report` renvoie une chaîne Microdown. Inspectez-la (`Cmd/Ctrl+I`) ou affichez-la (`Cmd/Ctrl+P`). Un nouveau rapport est produit à chaque appel, donc appeler `report` deux fois donne le même résultat.

### Faire le rapport d'une classe quelconque

```smalltalk
(Documentor on: OrderedCollection) report.
```

### Enregistrer le rapport dans un fichier

```smalltalk
| report |
report := (Documentor on: DocFakeDog) report.
'/tmp/DocFakeDog.md' asFileReference writeStreamDo: [ :stream |
    stream nextPutAll: report ].
```

### Utiliser les métriques sans rapport

```smalltalk
metrics := ClassMetrics on: DocFakeDog.
metrics depthOfInheritance.        "3"
metrics inheritedFieldsCount.      "2"
metrics definedFieldsCount.        "1"
metrics definedMethodsCount.       "3"
metrics superSendingMethods.       "la méthode compilée DocFakeDog>>#describe"

metrics longMethodThreshold: 5.
metrics longMethods.               "la méthode compilée DocFakeDog>>#longMethod"
```

### Exemple de sortie

Pour `(Documentor on: DocFakeDog) report`, le résultat ressemble à ceci. Les espaces exacts dépendent de votre version de Microdown, et les `...` remplacent des parties qui dépendent de votre image.

```md
# DocFakeDog
A subclass of DocFakeAnimal
has the following fields:  #breed
in defined in package `Documentor-Tests`

With a first comment paragraph: ...

## Class hierarchy
- ProtoObject
  - Object
    - DocFakeAnimal
      - **DocFakeDog**

## Has methods:
- `bark` - Makes the dog bark.
- `describe` - Returns a description of the dog.
- `longMethod`

## Metrics
- Depth of inheritance: 3
- Inherited fields: 2
- Defined fields: 1
- Inherited methods: ...
- Defined methods: 3
- Methods invoking super methods: ... DocFakeDog>>#describe ...
- Long methods: ...
```

Le texte du rapport reste en anglais, comme dans le code.

## Fonctionnement du code

### `Documentor`

**Côté classe**

- `on: aClass` crée un `Documentor` pour `aClass`. Il utilise `targetClass:` et renvoie la nouvelle instance.

**Point d'entrée**

- `report` crée un **nouveau** builder, appelle les méthodes de section dans l'ordre, puis renvoie `builder contents`. L'ordre est : nom de la classe, héritage, champs, package, commentaire, hiérarchie, méthodes, métriques. Créer le builder ici, et n'appeler `contents` qu'une seule fois à la fin, permet aux sections de partager un seul document et rend `report` répétable.

**Méthodes de section** (elles écrivent dans le builder partagé et ne renvoient rien d'utile)

- `reportClassName` écrit un titre de niveau 1 avec le nom de la classe.
- `reportInheritance` écrit un paragraphe « A subclass of » suivi du nom de la superclasse.
- `reportFields` écrit un paragraphe « has the following fields: » suivi d'un ` #nom` par champ. Elle utilise `instVarNames`, donc seuls les champs définis dans la classe elle-même sont listés (les champs hérités sont comptés dans les métriques).
- `reportPackage` écrit un paragraphe avec le nom du package en monospace.
- `reportComment` écrit un paragraphe avec le premier paragraphe du commentaire de classe, obtenu avec `firstParagraphOfComment`.
- `reportHierarchy` écrit un titre de niveau 2, puis construit la chaîne `allSuperclasses reversed , { targetClass }` (de la racine jusqu'à la cible) et la passe à `reportChain:`.
- `reportChain:` est récursive. Chaque appel écrit un élément de liste contenant la première classe de la chaîne, le reste de la chaîne étant dans une liste imbriquée. Quand il ne reste qu'une classe (la cible), elle est écrite en gras et suivie de ses sous-classes directes via `reportSubClassesOf:`.
- `reportSubClassesOf:` liste les sous-classes directes d'une classe dans une liste imbriquée, triées par nom. Elle n'écrit rien s'il n'y en a pas. Seules les sous-classes directes sont affichées, pour qu'une classe proche du sommet de la hiérarchie ne submerge pas le rapport.
- `reportMethods` liste les méthodes définies dans la classe (`localMethods`), triées par sélecteur. Chaque élément montre le sélecteur en monospace et, si la méthode en a un, son premier commentaire, obtenu avec `DocMethod>>firstCommentOf:`. Une méthode sans commentaire est quand même listée.
- `reportMetrics` crée un `ClassMetrics` sur la classe cible et écrit un élément de liste par métrique.

**Méthode utilitaire**

- `firstParagraphOfComment` analyse le commentaire de classe avec `MicrodownParser`, prend le premier `MicParagraphBlock` parmi les enfants de la racine et renvoie son texte. Elle renvoie une chaîne vide si le commentaire n'a pas de paragraphe. Un paragraphe se termine à une **ligne vide** : un simple retour à la ligne ne le termine pas, et une ligne « vide » qui contient un espace peut ne pas le terminer non plus.

**Accesseur**

- `targetClass:` enregistre la classe à documenter.

### `ClassMetrics`

Définitions utilisées par les métriques (ce sont des choix, et les tests les fixent) :

| Méthode | Signification |
|---|---|
| `depthOfInheritance` | Nombre de superclasses au-dessus de la classe (`allSuperclasses size`). |
| `inheritedFieldsCount` | Nombre de champs déclarés au-dessus de la classe, `0` sans superclasse. |
| `definedFieldsCount` | Nombre de champs déclarés dans la classe elle-même. |
| `definedMethodsCount` | Nombre de méthodes définies dans la classe elle-même (`localMethods`). |
| `inheritedMethodsCount` | Sélecteurs connus de la superclasse que la classe ne définit **pas** elle-même. Une méthode redéfinie compte comme définie, pas comme héritée. |
| `superSendingMethods` | Méthodes locales dont l'AST contient un envoi de message dont le receveur est `super`. Un envoi à `super` n'importe où dans la méthode compte, même dans un bloc ou avec un autre sélecteur. |
| `longMethods` | Méthodes locales dont le code source a plus de lignes que `longMethodThreshold`. |
| `longMethodThreshold:` | Fixe le seuil. La valeur par défaut est définie dans `initialize` (15 lignes). |

Autres méthodes : `on:` (constructeur côté classe) et `targetClass:` (accesseur).

### `DocMethod`

- `firstCommentOf: aMethod` renvoie le texte du premier commentaire de l'AST de la méthode (`ast comments`), ou une chaîne vide si la méthode n'a pas de commentaire.

## Tests

### Lancer les tests

- Cliquez sur l'icône en forme de cercle à côté d'une classe de test dans le System Browser, ou
- Ouvrez le Test Runner (menu World, Tools), sélectionnez `Documentor-Tests` et cliquez sur Run Selected.

### `DocumentorTest`

Tous appellent `(Documentor on: ...) report` et vérifient le texte. Ils utilisent `includesSubstring:`, ce qui est acceptable dans les tests, car la règle « pas de manipulation de chaînes » concerne le code qui produit la sortie.

| Test | Comportement vérifié |
|---|---|
| `testReportMentionsClassName` | Le rapport contient `DocFakeDog`. |
| `testReportMentionsSuperClass` | Le rapport sur `DocFakeDog` contient `DocFakeAnimal`. |
| `testReportMentionsFields` | Le rapport contient le champ `breed`. |
| `testReportMentionsPackage` | Le rapport contient `Documentor-Tests`. |
| `testReportMentionsFirstParagraphOfComment` | Le rapport sur `DocFakeAnimal` contient le premier paragraphe du commentaire et ne contient **pas** le texte du second. |
| `testReportMentionsHierarchyPosition` | Le rapport sur `DocFakeDog` contient `Object` et `DocFakeAnimal`. |
| `testHierarchyShowsAllSuperClassesInOrder` | `ProtoObject`, `Object` et `DocFakeAnimal` apparaissent dans cet ordre. Chaque recherche commence après le résultat précédent, car `Object` est aussi une sous-chaîne de `ProtoObject` et `DocFakeAnimal` est déjà mentionné plus haut (« A subclass of »). |
| `testHierarchyListsDirectSubclasses` | Le rapport sur `DocFakeAnimal` contient sa sous-classe `DocFakeDog`. |
| `testReportListsMethodsWithFirstComment` | Le rapport sur `DocFakeAnimal` contient la section « Has methods », la méthode `name` et son premier commentaire. |
| `testReportWithoutCommentIsListed` | Une méthode sans commentaire (`age`) est quand même listée. |

### `ClassMetricsTest`

| Test | Comportement vérifié |
|---|---|
| `testDepthOfInheritance` | `DocFakeDog` a une profondeur de 3 (`DocFakeAnimal`, `Object`, `ProtoObject`). |
| `testInheritedFieldsCount` | `DocFakeDog` hérite de 2 champs (`name`, `age`). |
| `testDefinedFieldsCount` | `DocFakeDog` définit 1 champ (`breed`). |
| `testDefinedMethodsCount` | Le nombre est égal à `localMethods size`. C'est circulaire, voir ci-dessous. |
| `testSuperSendingMethods` | Exactement une méthode de `DocFakeDog` envoie `super`, et c'est `describe`. |
| `testLongMethods` | Avec un seuil de 5, la seule méthode longue est `longMethod`. |

## Limites connues

- `Documentor on: ProtoObject` échoue, car `reportInheritance` demande le nom d'une superclasse qui vaut `nil`.
- `reportMetrics` affiche les méthodes qui appellent `super` et les méthodes longues avec le `printString` de la collection, qui imprime les méthodes compilées sous la forme `DocFakeDog>>#describe`. Une liste avec un élément par méthode (comme dans `reportMethods`) serait plus propre.
- `Documentor` ne permet pas de transmettre un seuil de méthode longue à son `ClassMetrics`. Il utilise toujours la valeur par défaut.
- `reportMethods` écrit son titre et sa liste à l'intérieur d'un paragraphe. Cela fonctionne, mais la structure est inhabituelle.
- `reportPackage` écrit « in defined in package », une coquille à corriger. Les tests ne vérifient que le nom du package, donc corriger la formulation ne les cassera pas.
- `testDefinedMethodsCount` calcule sa valeur attendue de la même façon que le code. La remplacer par le littéral `3` en fait une vraie vérification.
- `inheritedMethodsCount` n'a pas encore de test.
- Les noms des classes d'AST et de parser (`OC*`, `MicrodownParser`, `MicParagraphBlock`) dépendent de la version de Pharo.

## Prochaine étape : version 4 (mini linter)

Un visiteur (sous-classe de `OCProgramNodeVisitor`) qui signale les méthodes n'accédant à aucune variable d'instance, et celles qui n'accèdent ni à `self` ni aux variables d'instance. L'analyse sera dans ses propres classes, et `Documentor` ne fera que présenter les résultats.