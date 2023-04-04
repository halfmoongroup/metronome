"
Class: Used to control logging of data events.

Responsibility: 

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	isLogging:		<Object>


    Implementation Points
"
Class {
	#name : #LWLogger,
	#superclass : #Object,
	#instVars : [
		'isLogging'
	],
	#category : #LocalWeather
}

{ #category : #accessing }
LWLogger >> isLogging [

	^ isLogging
]

{ #category : #accessing }
LWLogger >> isLogging: anObject [

	isLogging := anObject
]

{ #category : #utilities }
LWLogger >> logEvent: name aTime: time aCount: count [

	Transcript show: self className ; show: '  '.
	Transcript show: name.
	time ifNotNil: [	Transcript  show:  time ].
	count ifNotNil: [	Transcript  show: ' count '; show: count ].
	Transcript cr.
	^ self.
]
