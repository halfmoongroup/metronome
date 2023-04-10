"
Class:  Manage the aquisition and presistence of data. 

Responsibility: The server code listens to the MQTT broker and then 
ses the JSON to create the object. The Object is 
Collaborators:  State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	context:		Manages the persistence of data
	deviceId:		<Object>
	logging:		<Object>
	observationPromise:		<Object>
	runing:		<Object>
	task:		<Object>
	taskBlock:		<Object>


    Implementation Points
"
Class {
	#name : #LWServer,
	#superclass : #Object,
	#instVars : [
		'context',
		'runing',
		'taskBlock',
		'deviceId',
		'logging',
		'logger',
		'observationPromise',
		'task'
	],
	#category : #LocalWeather
}

{ #category : #testing }
LWServer >> canRun [ 

	^ task isNil and: [ taskBlock notNil  ].
]

{ #category : #accessing }
LWServer >> context [

	^ context
]

{ #category : #accessing }
LWServer >> context: anObject [

	context := anObject
]

{ #category : #running }
LWServer >> getObservation [

	| json observation |
	observationPromise
		ifNil: [ 
			self getObservationPromise.
			^ nil ]
		ifNotNil: [ 
			observationPromise hasValue ifTrue: [ 
				json := observationPromise value.
				json ifNil: [ ^nil]. 
					observationPromise := nil.
					observation := [  NeoJSONReader fromString: json as: LWObservation]
						on: Exception do:[nil].
				observation ifNotNil: [ observation message: json].	
				^observation ]
				ifFalse: [^nil]
		]
		
			
	
]

{ #category : #accessing }
LWServer >> getObservationPromise [

	^observationPromise   ifNil: [
		 observationPromise := self taskBlock promiseAt: (Processor userBackgroundPriority)].
	
]

{ #category : #initialization }
LWServer >> initialize [ 
	logging := false.
	context := LWServerContext new. 
	logger := LWLogger new. 

]

{ #category : #accessing }
LWServer >> isRuning [

	^ task isNotNil and: [ task isActiveProcess  ]
]

{ #category : #accessing }
LWServer >> logging [

	^ logging
]

{ #category : #accessing }
LWServer >> logging: aswitch [

	logger isLogging: aswitch 
]

{ #category : #running }
LWServer >> run [

	| observation count |
	count := 0.
	self canRun ifTrue: [ 
		task := [ 
				  Transcript show: 'running'; cr. count := 0.
		        [ context captureComplete ] whileTrue: [ 
			        observation := self getObservation.
				  Transcript show: 'observation'; show: observation; cr. count := 0.
			        observation ifNotNil: [ 
				        observation isValidObsevation ifTrue: [ 
					        self context saveObservation: observation ] ] ] 
		 ]  forkAt: Processor userBackgroundPriority
			        named: 'Obs Capture' ].
		Transcript show: (task isActiveProcess).
	^ task
]

{ #category : #running }
LWServer >> runOnce [

	| observation count |
	Transcript
		show: 'running ';
		cr.
	count := 0.
	observation := self getObservation.
	Transcript
		show: 'observation" ';
		show: observation;
		cr.
	count := 0.
	observation ifNotNil: [ 
		observation isValidObsevation ifTrue: [ 
			self context saveObservation: observation ] ].
	task ifNotNil:[Transcript show: task isActiveProcess].
	^ task
]

{ #category : #accessing }
LWServer >> task [

	^ task
]

{ #category : #accessing }
LWServer >> task: anObject [

	task := anObject
]

{ #category : #accessing }
LWServer >> taskBlock [

	^ taskBlock
]

{ #category : #accessing }
LWServer >> taskBlock: anObject [

	taskBlock := anObject
]
