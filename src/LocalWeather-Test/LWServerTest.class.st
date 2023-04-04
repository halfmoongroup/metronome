Class {
	#name : #LWServerTest,
	#superclass : #TestCase,
	#category : #'LocalWeather-Test'
}

{ #category : #tests }
LWServerTest >> testBuffer [

	| server testValue | 
	
	server := LWBuffer new. 
	server addObservation:  1.
	self assert: server buffer size equals: 1. 
   testValue := server deleteObservation.
	self assert: testValue equals: 1. 
	self assert: server buffer size equals: 0. 


]

{ #category : #tests }
LWServerTest >> testInitializeServer [

	| server  |
	
	server := LWServer new.
	self assert: server taskBlock  isNil.
	self assert: server context countLimit  equals:  0.
	self assert: server context savedCount equals: 0.
	self assert: server context countLimit equals:0.
	
]

{ #category : #tests }
LWServerTest >> testMessageBuffer [

	| server obs1 obs2 obs3 session | 
	
	server := LWServer new. 
	server context sessionType: 'test'.
	session := server context session.
	
	self assert: session class equals: LWLocalSession .
		
	obs1 := LWObservation new.
	obs1  messageType: 49; timeStr:  '2023-03-12 18:28:50.098309'.
	obs2 := LWObservation new.
	obs2 messageType: 49; timeStr:  '2023-03-12 18:28:50.098309'.
	obs3 := LWObservation new. 
	obs3 messageType: 49; timeStr: '2023-03-12 18:39:50.098309'.

   server saveObservation: obs1. 
	server saveObservation: obs2.
	server saveObservation: obs3 .
	self assert: ( (server context) hasSeen: obs1) equals: true. 
	self assert: ( (server context) hasSeen: obs1) equals: true. 
	self assert: ( (server context) hasSeen: obs1) equals: true. 


]
