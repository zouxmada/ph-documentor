Class {
	#name : 'ClassMetricsTest',
	#superclass : 'TestCase',
	#category : 'Documentor-Tests',
	#package : 'Documentor-Tests'
}

{ #category : 'tests' }
ClassMetricsTest >> testDefinedFieldsCount [
	self assert: (ClassMetrics on: DocFakeDog ) definedFieldsCount equals: 1
]

{ #category : 'tests' }
ClassMetricsTest >> testDefinedMethodsCount [
	self assert: (ClassMetrics on: DocFakeDog ) definedMethodsCount equals: (DocFakeDog localMethods size)
]

{ #category : 'tests' }
ClassMetricsTest >> testDepthOfInheritance [
	self assert: (ClassMetrics on: DocFakeDog ) depthOfInheritance equals: 3
]

{ #category : 'tests' }
ClassMetricsTest >> testInheritedFieldsCount [
	self assert: (ClassMetrics on: DocFakeDog ) inheritedFieldsCount equals: 2
]

{ #category : 'tests' }
ClassMetricsTest >> testLongMethods [
	| metrics |
	metrics := ClassMetrics on: DocFakeDog.
	metrics longMethodThreshold: 5.
	self assert: (metrics longMethods collect: #selector) asArray equals: #(#longMethod)
]

{ #category : 'tests' }
ClassMetricsTest >> testSuperSendingMethods [
	self assert: (ClassMetrics on: DocFakeDog ) superSendingMethods size equals: 1.
	self assert: (ClassMetrics on: DocFakeDog ) superSendingMethods first selector equals: #describe
]
