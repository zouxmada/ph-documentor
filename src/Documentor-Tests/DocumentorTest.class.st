Class {
	#name : 'DocumentorTest',
	#superclass : 'TestCase',
	#category : 'Documentor-Tests',
	#package : 'Documentor-Tests'
}

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
