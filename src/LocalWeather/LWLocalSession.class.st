"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

Class: A proxy object that can be used in place of a database backed storage session

Responsibility: This object is used in testing. It's purpose is to be a place holder for the glorp session.
It only implements the minimal set of messages that will alow it to be used in place of the glorp session. 


For the Collaborators Part: Used in tests as a subsitute for the glorp session.

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	linkedList:		<Object>


    Implementation Points
"
Class {
	#name : #LWLocalSession,
	#superclass : #Object,
	#instVars : [
		'linkedList'
	],
	#category : #LocalWeather
}

{ #category : #enumerating }
LWLocalSession >> inUnitOfWorkDo: aBlock [


	^ aBlock value
]

{ #category : #initialization }
LWLocalSession >> initialize [ 
	
	linkedList := LinkedList new. 
]

{ #category : #testing }
LWLocalSession >> isLoggedIn [ 
	^true
]

{ #category : #accessing }
LWLocalSession >> linkedList [

	^ linkedList
]

{ #category : #accessing }
LWLocalSession >> linkedList: anObject [

	linkedList := anObject
]

{ #category : #registry }
LWLocalSession >> register: aMessage [

	self linkedList add: aMessage
]
