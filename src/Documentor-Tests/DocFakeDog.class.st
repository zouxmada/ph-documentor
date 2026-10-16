Class {
	#name : 'DocFakeDog',
	#superclass : 'DocFakeAnimal',
	#instVars : [
		'breed'
	],
	#category : 'Documentor-Tests',
	#package : 'Documentor-Tests'
}

{ #category : 'printing' }
DocFakeDog >> bark [
	"Makes the dog bark."
	^ 'Woof'
]
