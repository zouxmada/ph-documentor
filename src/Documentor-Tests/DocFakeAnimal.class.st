"
I represent an animal.

I have a name and an age. This second paragraph should not appear in the report.
"
Class {
	#name : 'DocFakeAnimal',
	#superclass : 'Object',
	#instVars : [
		'name',
		'age'
	],
	#category : 'Documentor-Tests',
	#package : 'Documentor-Tests'
}

{ #category : 'accessing' }
DocFakeAnimal >> age [
	^ age
]

{ #category : 'printing' }
DocFakeAnimal >> describe [
	"Return a description of the animal."
	^ 'An animal'
]

{ #category : 'accessing' }
DocFakeAnimal >> name [
	"Returns the name of the animal."
	^ name
]
