Misy packages 2 ao amle projet
- **Documentor** : Package principal
- **Documentor-Tests** : Misy ny tests

TDD (Test Driven Development) no nanaovana anle izy de tests zany no nosoratana voloany

## Documentor-Tests

Misy Class roa zay ao : `DocFakeAnimal` sy `DocFakeDog` hanaovana ny tests rehetra.

> Tsy nampiasa anle `OrderedCollector` ohatran'ny tao amle sujet ah satria mety miova io `OrderCollector` io raha misy mis à jour Pharo de aleo mamorona classes hanaovana tests fotsiny

Misy anle classe `DocumentorTest` ndray, ao daholo ny methodes de tests ho anle `Documentor`

### testReportMentionsClassName

Methode de test ho an'ny V1 , afficher nom de classe.
Methode mi-vérifier oe tena affiché tokoa ve ilay anarana classe notadiavina raha miantso anle methode `report` ao amin'ny `Documentor`.

### testReportMentionsFields

Methode de test ho an'ny V1, afficher les fields (slots).
Methode mi-vérifier oe ao ny slots (variables de classe) rehetra raha miantso anle methode `report`.

### testReportMentionsPackage

Methode de test v1, afficher le nom du package de la classe.
Methode mi-vérifier oe ao ny package name anle classe raha miantso anle methode `report`.

### testResportMentionsSuperclass
Methode de test v1
Methode mi-vérifier oe ao ny superclass (classe parent) name anle classe raha miantso anle methode `report`.

---

### testReportMentionsFirstParagraphOfComment
Methode de test v2, afficher le premier paragraphe du commentaire de la classe.
Methode mi-vérifier oe ao ny premier paragraphe du commentaire anle classe ary ny premier paragraphe ihany no tokony miseho, raha miantso anle methode `report`.

### testHierarchyListsDirectSubclasses
Methode de test v2, afficher l'hierarchie de la classe avec sa position.
Methode mi-vérifier oe ao ny classe enfant rehefa mi-afficher ny hierarchie anle classe raha miantso anle methode `report`.

### testHierarchyShowsAllSuperClassesInOrder
Methode de test v2, afficher l'hierarchie de la classe avec sa position.
Methode mi-vérifier oe milahatra tsara ny superclasses rehetra anle classe, miankina amin'ny niveau hierarchique anle super classe.

### testReportMentionsHierarchyPosition
Methode de test v2, afficher l'hierarchie de la classe avec sa position.
Methode mi-vérifier oe ao daholo ny classe hierarchique rehetra anle classe

### testReportListsMethodsWithFirstComment
Methode de test v2, afficher les méthodes et ses premier commentaires.
Methode mi-vérifier oe affiché tokoa ny anaranle methode sy ny commentaire voalohany.

### testReportWithoutCommentIsListed
Methode de test v2, afficher les méthodes et ses premier commentaires.
Methode mi-vérifier oe affiché foana ny methode na tsy misy commentaires aza.

---

## ClassMetricsTest

### testInheritedFieldsCount
Methode de test v3, afficher le nombre de champs (slots) hérités de la classe parent.
Methode mi-vérifier oe tena le isany tokony ho izy ny champs hérités tamin'ny classe parent.

### testDefinedFieldsCount
Methode de test v3, afficher le nombre de champs (slots) défini dans la classe.
Methode mi-vérifier oe tena le isany tokony ho izy ny champs définis dans la classe.

### testDefinedMethodsCount
Methode de test v3, afficher le nombre de methodes définies dans la classe.

### testInheritedMethodsCount
Methode de test v3, afficher le nombre de methodes hérités de la classe parent.

### testDepthOfInheritance
Methode de test v3, afficher la profondeur d'héritage de la classe.

### testLongMethods
Methode de test v3, afficher les methodes longues.

### testSuperSendingMethods
Methode de test v3, afficher les methodes qui appellent des methodes de la classe parent.

Mi-fail daholo reo tests reo amin'ny voalohany satria mbola tsy misy implementées na le classe `Documentor` na ny methodes ao aminy.

---

## Documentor

Classe hanaovana ny reports (affichage nle zavatra tadiavin'ny exercices).

Manana propriétés (slots) roa:
- `targetClass` : le classe tiana ho étudiena
- `builder` : instance `MicMicrodownTextualBuilder`, fi-affichena anle résultats.

Méthodes

### on: aClass
Méthode mandray paramètre `aClass` ; hi-assignena anle classe cible.

### targetClass: aClass
Méthode `setter` ho anle propriété `targetClass` ; appellena ao amin'ny méthode `on: aClass`

### reportClassName
Méthode mi-retourner nom de la classe cible. (v1)

### reportFields
Méthode mi-retourner champs (slots) de la classe cible. (e.g: targetClass, fields pour Documentor) (v1)

### reportInheritance 
Méthode mi-retourner ny nom de la classe parent. (v1)

### reportPackage
Méthode mi-retourner nom du package de la classe cible. (v1)

### firstParagraphOfComment
Méthode mi-retourner premier paragraphe du commentaire de la classe cible. (v2)

### reportComment
Méthode mi-retourner premier paragraphe du commentaire de la classe cible. Mampiasa ny methode `firstParagraphOfComment` (v2)

### reportHierarchy
Méthode mi-retourner hierarchie de la classe cible (Parents - classe cible - enfants) en order. (v2)

### reportChain
Méthode mi-retourner en liste ny hierarchie an'ny classe cible. (recursive), antsoina ao amin'ny methode `reportHierarchy` (v2)

### reportSubClassesOf: aClass
Méthode mi-retourner en liste ordonnée ny enfants de la classe `aClass`. Antsoina ao amin'ny methode `reportChain` (v2)

### reportMethods
Méthode mi-retourner ny methodes avec le premier commentaire (de la methode) anle classe cible. (v2)

### reportMetrics

Méthode mi-retourner ny métriques rehetra takiana ao amin'ny v3

### report

Méthode principale miantso ny `report*` rehetra (affichage finale).

--

## ClassMetrics

Classe natokana ho an'ny métriques, ao amin'ny v3.

Manana propriétés (slots) roa:
- `targetClass` : le classe tiana ho étudiena
- `longMethodThreshold` : ny longueur ny atao hoe methode lava

### on: aClass
Méthode mi-définir ny classe ho étudiena.

### targetClass: aClass
Méthode mi-set ny `targetClass`. Ampiasaina ao amin'ny methode `on: aClass`

### depthOfInheritance
Methode mi-retourner ny isan'ny classe parent anle classe cible (profondeur d'héritage).

### inheritedFieldsCount
Methode mi-retourner ny isan'ny propriétés (slots) héritées de la classe parent.

### definedFieldsCount
Methode mi-retourner ny isan'ny propriétés (slots) définies dans la classe cible.

### inheritedMethodsCount
Methode mi-retourner ny isan'ny methodes héritées de la classe parent.

### definedMethodsCount
Methode mi-retourner ny isan'ny methodes définies dans la classe cible.

### superSendingMethods
Methode mi-retourner ny isan'ny methodes miantso méthodes de la classe parent.

### longMethods
Methode mi-retourner ny isan'ny methodes lava be ny contenu.

### initialize
Methode constructeur, mi-set ny `longMethodeThreshold` ho 15 eto.

### longMethodThreshold: anInteger
Methode `setter` ho an'ny `longMethodThreshold` ; antsoina ao amin'ny methode `initialize`.

## Quetion tsara apetraka

Le sujet niteny oe `it means that the tool should not explicitly manipulate strings!` ; midika ve zany oe tsy tokony mikirakira `string` de nefa nataoko ihany aloha zay any amin'ny tests sasany (le sujet koa niteny oe le reporter no tsy tokony hi-manipuler string de mety tsy maninona ihany zany raha oe any amin'ny tests no misy string manipulation)