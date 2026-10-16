Class {
	#name : 'DocumentorTest',
	#superclass : 'TestCase',
	#category : 'Documentor-Tests',
	#package : 'Documentor-Tests'
}

{ #category : 'tests' }
DocumentorTest >> testHierarchyListsDirectSubclasses [
	| report |
	report := (Documentor on: DocFakeAnimal ) report.
	self assert: (report includesSubstring: 'DocFakeDog')
]

{ #category : 'tests' }
DocumentorTest >> testHierarchyShowsAllSuperClassesInOrder [
	| report proto object animal |
	report := (Documentor on: DocFakeDog ) report.
	proto := report indexOfSubCollection: 'ProtoObject'.
	object := report indexOfSubCollection: 'Object' startingAt: proto + 'ProtoObject' size.
	animal := report indexOfSubCollection: 'DocFakeAnimal' startingAt: object .
	self assert: proto > 0.
	self assert: object > proto.
	self assert: animal > object
]

{ #category : 'tests' }
DocumentorTest >> testReportListsMethodsWithFirstComment [
	| report |
	report := (Documentor on: DocFakeAnimal ) report.
	self assert: (report includesSubstring: 'Has methods').
	self assert: (report includesSubstring: 'name').
	self assert: (report includesSubstring: 'Returns the name of the animal.')
]

{ #category : 'tests' }
DocumentorTest >> testReportMentionsClassName [
	| report |
	report := (Documentor on: DocFakeDog ) report.
	self assert: (report includesSubstring: 'DocFakeDog')
]

{ #category : 'tests' }
DocumentorTest >> testReportMentionsFields [
	| report |
	report := (Documentor on: DocFakeDog ) report.
	self assert: (report includesSubstring: 'breed')
]

{ #category : 'tests' }
DocumentorTest >> testReportMentionsFirstParagraphOfComment [
	| report |
	report := (Documentor on: DocFakeAnimal ) report.
	self assert: (report includesSubstring: 'I represent an animal').
	self deny: (report includesSubstring: 'should not appear')
]

{ #category : 'tests' }
DocumentorTest >> testReportMentionsHierarchyPosition [
	| report |
	report := (Documentor on: DocFakeDog ) report.
	self assert: (report includesSubstring: 'Object').
	self assert: (report includesSubstring: 'DocFakeAnimal')
]

{ #category : 'tests' }
DocumentorTest >> testReportMentionsPackage [
	| report |
	report := (Documentor on: DocFakeDog ) report.
	self assert: (report includesSubstring: 'Documentor-Tests')
]

{ #category : 'tests' }
DocumentorTest >> testReportMentionsSuperClass [
	| report |
	report := (Documentor on: DocFakeDog ) report.
	self assert: (report includesSubstring: 'DocFakeAnimal')
]

{ #category : 'tests' }
DocumentorTest >> testReportWithoutCommentIsListed [
	| report |
	report := (Documentor on: DocFakeAnimal ) report.
	self assert: (report includesSubstring: 'Has methods').
	self assert: (report includesSubstring: 'age')
]
