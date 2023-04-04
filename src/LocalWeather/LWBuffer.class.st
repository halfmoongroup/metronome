"
Class: A simple buffer that holds a set number of entries. 

Responsibility: Keep track of a small number of entries to prevent duplication of observations. it's a simole list of entries limited to a specific size. As new entries are inserted the oldest entry is remoced. The list stays a constant size. 

Collaborators: Used by LWContext to keep track of recently arriving observationa and keep the system from persisiting identical entries. 

Public API and Key Messages

- addObservation = add an entry to be    
- anyObservation - pass in an object and return true if it's in the list
- limit 			  - set the size of the number of elements in the list defaults to 8
- deleteObservation - private method. 

- how to create instances.

  buffer := LWBuffer new. 
 
Internal Representation and Key Implementation Points.

    Instance Variables
	buffer:		LinkedList
	bufferLimit:		Integer


    Implementation Points
"
Class {
	#name : #LWBuffer,
	#superclass : #Object,
	#instVars : [
		'buffer',
		'bufferLimit'
	],
	#category : #LocalWeather
}

{ #category : #filtering }
LWBuffer >> addObservation: observation [

	self buffer add: observation.
	(bufferLimit < self buffer  size) ifTrue: [ 
		self buffer removeFirst.
	] 
]

{ #category : #enumerating }
LWBuffer >> anySatisfy: aBlock [

	^self buffer anySatisfy: aBlock. 
]

{ #category : #accessing }
LWBuffer >> buffer [

	^ buffer
]

{ #category : #accessing }
LWBuffer >> buffer: anObject [

	buffer := anObject
]

{ #category : #filtering }
LWBuffer >> deleteObservation [

	^self buffer removeFirst. 
]

{ #category : #initialization }
LWBuffer >> initialize [ 

	buffer := LinkedList new.
	bufferLimit := 8
]

{ #category : #accessing }
LWBuffer >> limit [

	^ bufferLimit
]

{ #category : #accessing }
LWBuffer >> limit: aNumber [

	bufferLimit := aNumber
]

{ #category : #accessing }
LWBuffer >> size [ 

	^buffer size. 
]
