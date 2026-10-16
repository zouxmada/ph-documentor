Class {
	#name : 'DocMethod',
	#superclass : 'Object',
	#category : 'Documentor',
	#package : 'Documentor'
}

{ #category : 'accessing' }
DocMethod >> firstCommentOf: aMethod [
	^ aMethod ast comments
		ifEmpty: [ '' ]
		ifNotEmpty: [ :comments | comments first contents ]
]
