Class {
	#name : #LWServerTest,
	#superclass : #TestCase,
	#category : #'LocalWeather-Test'
}

{ #category : #'as yet unclassified' }
LWServerTest class >> observationJson [ 

	^  '{
    "time": "2023-03-14 07:33:18.401413",
    "protocol": 40,
    "model": "Acurite-5n1",
    "message_type": 49,
    "id": 1079,
    "channel": "C",
    "sequence_num": 1,
    "battery_ok": 1,
    "wind_avg_km_h": 0,
    "wind_dir_deg": 0,
    "rain_in": 11.67,
    "mic": "CHECKSUM",
    "mod": "ASK",
    "freq": 433.932,
    "rssi": -7.566,
    "snr": 24.879,
    "noise": -32.445
  }'
]

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
LWServerTest >> testGetObservation [

	| server result1 result2 semaphore|
	
	server := LWServer new. 
	semaphore := nil.
	semaphore := Semaphore new. 
	server taskBlock: [ semaphore wait. self class observationJson    ].
	result1 := server getObservation.
	result2 := server getObservation.
	self assert: result1 equals: result2. 
	self assert: result1 equals: nil. 
	self assert: result2 equals: nil.
	semaphore signal.
	(Delay forMilliseconds: 100) wait. 
	result1 := server getObservation.
	self assert: result1 className equals: 'LWObservation'

]

{ #category : #tests }
LWServerTest >> testGetObservationPromise [

	| server promise semaphore |
	semaphore := Semaphore new.
	server := LWServer new. 
	server taskBlock: [ semaphore wait. 6 ].
	promise := server getObservationPromise.
	self assert: 'Promise' equals: promise className.
	self assert: promise hasValue equals: false.
	semaphore signal.
	(Delay forMilliseconds: 100) wait. 
	self assert: promise hasValue equals: true. 
 
	self assert: promise value equals:   6. 

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
