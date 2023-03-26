Class {
	#name : #LWServer,
	#superclass : #Object,
	#instVars : [
		'runing',
		'buffer',
		'bufferLimit',
		'taskBlock',
		'session',
		'sessionType',
		'deviceId',
		'savedObservationCount',
		'observationCountLimit',
		'logging',
		'sessionFactory',
		'observationPromise'
	],
	#category : #LocalWeather
}

{ #category : #accessing }
LWServer >> buffer [

	^ buffer
]

{ #category : #accessing }
LWServer >> buffer: anObject [

	buffer := anObject
]

{ #category : #filtering }
LWServer >> bufferAddObservation: observation [

	self buffer add: observation 
]

{ #category : #filtering }
LWServer >> bufferDelObservation [

	^self buffer removeFirst. 
]

{ #category : #accessing }
LWServer >> bufferLimit [

	^ bufferLimit
]

{ #category : #accessing }
LWServer >> bufferLimit: aNumber [

	bufferLimit := aNumber
]

{ #category : #persistence }
LWServer >> createSession [ 
	| sessionTemp |
	('persistent' = self sessionType) ifTrue: [ sessionTemp :=  LWSessionManager createDBSession  ]
	ifFalse: [self sessionType: (sessionTemp :=  LWSessionManager createTestSession) ].
	
	^ sessionTemp
]

{ #category : #accessing }
LWServer >> deviceId [

	^ deviceId
]

{ #category : #accessing }
LWServer >> deviceId: anObject [

	deviceId := anObject
]

{ #category : #running }
LWServer >> getObservation [

	| json  observation |
	observationPromise   ifNil: [
		 observationPromise := self taskBlock promise. 
		^nil ]
	ifNotNil: [  
		( observationPromise hasValue ) ifTrue: [
		json := observationPromise value.
		observationPromise := nil.
		observation := NeoJSONReader fromString: json as: LWObservation.
		observation message: json.
		^ observation
		]
	].
	^nil
]

{ #category : #initialization }
LWServer >> initialize [ 
	logging := false.
	buffer := LinkedList new.
	sessionType := 'persistent'.
	bufferLimit := 6.
	savedObservationCount := 0.
	observationCountLimit := 0.
	sessionFactory := LWSessionManager  new. 
]

{ #category : #utility }
LWServer >> logEvent: name aTime: time aCount: count [

	Transcript show: name.
	time ifNotNil: [	Transcript  show:  time ].
	count ifNotNil: [	Transcript  show: ' count '; show: count ].
	Transcript cr.
	^ self.
]

{ #category : #accessing }
LWServer >> logging [

	^ logging
]

{ #category : #accessing }
LWServer >> logging: anObject [

	logging := anObject
]

{ #category : #accessing }
LWServer >> observationCountLimit [

	^ observationCountLimit
]

{ #category : #accessing }
LWServer >> observationCountLimit: anObject [

	observationCountLimit := anObject
]

{ #category : #persistence }
LWServer >> persistObservation: obsevarion [

	| sessionTemp |
	sessionTemp := self session.
	sessionTemp inUnitOfWorkDo: [ sessionTemp register: obsevarion ].
	^savedObservationCount := savedObservationCount +1
]

{ #category : #utility }
LWServer >> pruneCurrentList [

	(5 < self buffer  size) ifTrue: [ 
		self buffer removeFirst.
	 ] 
]

{ #category : #running }
LWServer >> run [

	| observation count |
	count := 0.
	runing := true.
	taskBlock ifNil: [ ^ nil ].
	[ runing ] whileTrue: [ 
		observation := self getObservation.
		observation ifNotNil: [ 
			observation isValidObsevation ifTrue: [ 
				self saveObservation: observation.
				runing := self shouldContinue ] ].
		Processor yield ].
	^ self
]

{ #category : #accessing }
LWServer >> runing [

	^ runing
]

{ #category : #accessing }
LWServer >> runing: anObject [

	runing := anObject
]

{ #category : #filtering }
LWServer >> saveObservation: anObservation [

	(buffer anySatisfy: [ :each | each = anObservation ]) ifTrue: [ 
		self logging ifTrue: [ 
			self
				logEvent: 'not saved '
				aTime: anObservation timeStr
				aCount: buffer size ].
		^ self ].
	buffer add: anObservation.
	self pruneCurrentList.
		self logging ifTrue: [ 
			self
				logEvent: '    saved '
				aTime: anObservation timeStr
				aCount: buffer size ].
	self persistObservation: anObservation
]

{ #category : #accessing }
LWServer >> savedObservationCount [

	^ savedObservationCount 
]

{ #category : #accessing }
LWServer >> savedObservationCount: anObject [

	savedObservationCount  := anObject
]

{ #category : #accessing }
LWServer >> session [

	session ifNil: [  session :=  sessionFactory createSession: self sessionType ].
	session isLoggedIn ifFalse: [ session login ].
	^session. 
]

{ #category : #accessing }
LWServer >> session: anObject [

	session := anObject
]

{ #category : #accessing }
LWServer >> sessionFactory [

	^ sessionFactory
]

{ #category : #accessing }
LWServer >> sessionFactory: anObject [

	sessionFactory := anObject
]

{ #category : #accessing }
LWServer >> sessionType [

	^ sessionType
]

{ #category : #accessing }
LWServer >> sessionType: anObject [

	sessionType := anObject
]

{ #category : #asserting }
LWServer >> shouldContinue [
	
	(self observationCountLimit  ~= 0) ifTrue: [^(self savedObservationCount) < self observationCountLimit ].
	^true
]

{ #category : #accessing }
LWServer >> taskBlock [

	^ taskBlock
]

{ #category : #accessing }
LWServer >> taskBlock: anObject [

	taskBlock := anObject
]
