Class {
	#name : 'ClassMetrics',
	#superclass : 'Object',
	#instVars : [
		'targetClass',
		'longMethodThreshold'
	],
	#category : 'Documentor',
	#package : 'Documentor'
}

{ #category : 'instance creation' }
ClassMetrics class >> on: aClass [
	^ self new
		targetClass: aClass;
		yourself
]

{ #category : 'counter' }
ClassMetrics >> definedFieldsCount [
	^ targetClass instVarNames size
]

{ #category : 'counter' }
ClassMetrics >> definedMethodsCount [
	^ targetClass localMethods size
]

{ #category : 'counter' }
ClassMetrics >> depthOfInheritance [
	^ targetClass allSuperclasses size
]

{ #category : 'counter' }
ClassMetrics >> inheritedFieldsCount [
	^ targetClass superclass
		ifNil: [ 0 ]
		 ifNotNil: [ :superclass | superclass allInstVarNames size ] 
]

{ #category : 'counter' }
ClassMetrics >> inheritedMethodsCount [
	^ targetClass superclass
		ifNil: [ 0 ]
		 	ifNotNil: [ :superclass | 
				(superclass allSelectors reject: [ :each | targetClass includesSelector: each ]) size
			] 
]

{ #category : 'initialization' }
ClassMetrics >> initialize [ 
	super initialize .
	longMethodThreshold := 15
]

{ #category : 'accessing' }
ClassMetrics >> longMethodThreshold: anInteger [
	longMethodThreshold := anInteger 
]

{ #category : 'lint' }
ClassMetrics >> longMethods [ 
	^ targetClass localMethods select: [ :method |
		method sourceCode lines size > longMethodThreshold 
	]
]

{ #category : 'as yet unclassified' }
ClassMetrics >> superSendingMethods [
	^ targetClass localMethods select: [ :method |
		method ast sendNodes anySatisfy: [ :send | send receiver isSuperVariable ]
	]
]

{ #category : 'setter' }
ClassMetrics >> targetClass: aClass [
	targetClass := aClass 
]
