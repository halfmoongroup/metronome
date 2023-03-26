Class {
	#name : #LWServerTest,
	#superclass : #TestCase,
	#category : #'LocalWeather-Test'
}

{ #category : #tests }
LWServerTest >> testBuffer [

	| server testValue | 
	
	server := LWServer new. 
	server bufferAddObservation:  1.
	self assert: server buffer size equals: 1. 
   testValue := server bufferDelObservation.
	self assert: testValue equals: 1. 
	self assert: server buffer size equals: 0. 


]

{ #category : #tests }
LWServerTest >> testInitializeServer [

	| server  |
	
	server := LWServer new initialize.
	self assert: server taskBlock  isNil.
	self assert: server bufferLimit > 0.
	self assert: server savedObservationCount equals: 0.
	self assert: server buffer size equals:0.
	
]

{ #category : #tests }
LWServerTest >> testMessageBuffer [

	| server obs1 obs2 obs3 session | 
	
	server := LWServer new. 
	server sessionType: 'test'.
	session := server session.
	
	self assert: session class equals: LWLocalSession .
		
	obs1 := LWObservation new.
	obs1  messageType: 49; timeStr:  '2023-03-12 18:28:50.098309'.
	obs2 := LWObservation new.
	obs2 messageType: 49; timeStr:  '2023-03-12 18:28:50.098309'.
	obs3 := LWObservation new. 
	obs3 messageType: 49; timeStr: '2023-03-12 18:39:50.098309'.

   server saveObservation:  obs1. 
	self assert: server buffer size equals: 1. 
	server saveObservation: obs2.
	self assert: server buffer size equals: 1. 
	server saveObservation: obs3 .
	self assert: server buffer size equals: 2. 


]

{ #category : #tests }
LWServerTest >> testShouldContinue [
	| server |
	server := LWServer new. 
	self assert: server shouldContinue equals: true. 
	server savedObservationCount: 100. 
	self assert: server shouldContinue equals: true. 
	server observationCountLimit:  50. 
	self assert: server shouldContinue equals: false. 

]
