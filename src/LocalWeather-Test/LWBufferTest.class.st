Class {
	#name : #LWBufferTest,
	#superclass : #TestCase,
	#category : #'LocalWeather-Test'
}

{ #category : #tests }
LWBufferTest >> testAddObservation [
	| buffer |
	
	buffer := LWBuffer new. 
	buffer limit: 2.
	buffer addObservation: 2.
	self assert: buffer size equals: 1.
	buffer addObservation: 3.
	buffer addObservation: 4.
	self assert: buffer size equals: 2.

]

{ #category : #tests }
LWBufferTest >> testAnySatisfy [
	| buffer |
	buffer := LWBuffer new. 
	buffer limit: 3.
	buffer addObservation: 5.
	buffer addObservation: 1.
	buffer addObservation: 4.
	buffer addObservation: 2.
	self assert: buffer size equals: 3.
	self assert: (buffer anySatisfy: [ :each | each = 2]) equals: true. 
	self assert: (buffer anySatisfy: [ :each | each = 5]) equals: false. 
]
