Class {
	#name : 'Documentor',
	#superclass : 'Object',
	#instVars : [
		'targetClass',
		'builder'
	],
	#category : 'Documentor',
	#package : 'Documentor'
}

{ #category : 'instance creation' }
Documentor class >> on: aClass [
	^ self new
		targetClass: aClass ;
		yourself 
]

{ #category : 'accessing' }
Documentor >> firstParagraphOfComment [
	| root firstParagraph |
	root := MicrodownParser new parse: targetClass comment.
	firstParagraph := root children
		detect: [ :each | each isKindOf: MicParagraphBlock ]
		ifNone: [ ^ '' ].
	^ firstParagraph text
]

{ #category : 'reporting' }
Documentor >> report [
	builder := MicMicrodownTextualBuilder new.
	self reportClassName.
	self reportInheritance.
	self reportFields.
	self reportPackage.
	self reportComment.
	self reportHierarchy.
	self reportMethods.
	self reportMetrics.
	^ builder contents		
]

{ #category : 'reporting' }
Documentor >> reportChain: classes [
	classes ifEmpty: [ ^ self ].
	builder unorderedListDuring: [ 
		builder item: [ 
			classes size = 1
				ifTrue: [ builder bold: [ builder text: classes first name ] . self reportSubClassesOf: classes first ]
				ifFalse: [ builder text: classes first name. self reportChain: classes allButFirst ]
		]
	]
]

{ #category : 'reporting' }
Documentor >> reportClassName [
	builder header: [ builder text: targetClass name ] withLevel: 1
]

{ #category : 'reporting' }
Documentor >> reportComment [
	builder paragraph: [ 
		builder text: 'With a first comment paragraph: '.
		builder text: self firstParagraphOfComment 
	]
]

{ #category : 'reporting' }
Documentor >> reportFields [
	builder paragraph: [ 
		builder text: 'has the following fields: '.
		targetClass instVarNames do: [ :each | builder text: ' #'. builder text: each ]
	]
]

{ #category : 'reporting' }
Documentor >> reportHierarchy [
	| chain |
	chain := targetClass allSuperclasses reversed , { targetClass }.
	builder header: [ builder text: 'Class hierarchy' ] withLevel: 2.
	self reportChain: chain
]

{ #category : 'reporting' }
Documentor >> reportInheritance [
	builder paragraph: [ 
		builder text: 'A subclass of '.
		builder text: targetClass superclass name
	]
	 
]

{ #category : 'reporting' }
Documentor >> reportMethods [
	| method sorted |
	method := DocMethod new.
	sorted := targetClass localMethods sorted: [ :a :b | a selector  <= b selector ].
	builder paragraph: [ 
		builder header: [ builder text: 'Has methods: ' ] withLevel: 2.
		builder unorderedListDuring: [ 
			sorted do: [ :each |
				builder item: [ 
					builder monospace: each selector.
					( method firstCommentOf: each ) ifNotEmpty: [ :comment | 
						builder text: ' - '.
						builder text: comment 
					]
				]
			]
		]
	]
]

{ #category : 'reporting' }
Documentor >> reportMetrics [
	| metrics |
	metrics := ClassMetrics on: targetClass.
	builder header: [ builder text: 'Metrics' ] withLevel: 2.
	builder unorderedListDuring: [ 
		builder item: [ builder text: 'Depth of inheritance: ' . builder text: metrics depthOfInheritance printString ].
		builder item: [ builder text: 'Inherited fields: ' . builder text: metrics inheritedFieldsCount printString ].
		builder item: [ builder text: 'Defined fields: ' . builder text: metrics definedFieldsCount printString ].
		builder item: [ builder text: 'Inherited methods: ' . builder text: metrics inheritedMethodsCount printString ].
		builder item: [ builder text: 'Defined methods: ' . builder text: metrics definedMethodsCount printString ].
		builder item: [ builder text: 'Methods invoking super methods: ' . builder text: metrics superSendingMethods printString ].
		builder item: [ builder text: 'Long methods: ' . builder text: metrics longMethods printString ]
	]
		
]

{ #category : 'reporting' }
Documentor >> reportPackage [
	builder paragraph: [ 
		builder text: 'in defined in package '.
		builder monospace: targetClass package name
	]
]

{ #category : 'reporting' }
Documentor >> reportSubClassesOf: aClass [
	| sorted |
	sorted := aClass subclasses sorted: [ :a :b | a name <= b name ].
	sorted ifEmpty: [ ^ self ].
	builder unorderedListDuring: [ 
		sorted do: [ :each | builder item: [ builder text: each name ] ]
	]
]

{ #category : 'setter' }
Documentor >> targetClass: aClass [
	targetClass := aClass 
]
