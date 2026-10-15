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

{ #category : 'reporting' }
Documentor >> report [
	builder := MicMicrodownTextualBuilder new.
	self reportClassName.
	self reportInheritance.
	self reportFields.
	self reportPackage.
	^ builder contents		
]

{ #category : 'reporting' }
Documentor >> reportClassName [
	builder header: [ builder text: targetClass name ] withLevel: 1
]

{ #category : 'reporting' }
Documentor >> reportFields [
	builder paragraph: [ 
		builder text: 'has the following fields: '.
		targetClass instVarNames do: [ :each | builder text: ' #'. builder text: each ]
	]
]

{ #category : 'reporting' }
Documentor >> reportInheritance [
	builder paragraph: [ 
		builder text: 'A subclass of '.
		builder text: targetClass superclass name
	]
	 
]

{ #category : 'reporting' }
Documentor >> reportPackage [
	builder paragraph: [ 
		builder text: 'in defined in package '.
		builder monospace: targetClass package name
	]
]

{ #category : 'setter' }
Documentor >> targetClass: aClass [
	targetClass := aClass 
]
