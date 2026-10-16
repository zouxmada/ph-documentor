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

{ #category : 'printing' }
DocFakeDog >> describe [
	"Returns a description of the dog."
	^ super describe 
]

{ #category : 'calc' }
DocFakeDog >> longMethod [
	| a b c |
	a := 1.
	b := 2.
	c := 3.
	a := a + b.
	b := b + c.
	^ a + b + c
]
