Class {
	#name : #LWServerContext,
	#superclass : #Object,
	#instVars : [
		'session',
		'sessionType',
		'sessionFactory',
		'logger',
		'buffer',
		'savedCount',
		'countLimit'
	],
	#category : #LocalWeather
}

{ #category : #asserting }
LWServerContext >> captureComplete [
	
	^(countLimit  ~= 0) 
	ifTrue: 
		[^ (savedCount > countLimit) ];
	ifFalse: 
		[ ^false ]

]

{ #category : #accessing }
LWServerContext >> countLimit [

	^ countLimit 
]

{ #category : #accessing }
LWServerContext >> countLimit: anNumber [

 	countLimit := anNumber
]

{ #category : #validation }
LWServerContext >> hasSeen: anObservation [

	 ^ buffer anySatisfy: [ :each | each = anObservation ]
]

{ #category : #initialization }
LWServerContext >> initialize [ 
	buffer :=  LWBuffer new. 
	sessionType := 'persistent'.
	sessionFactory := LWSessionManager  new. 
	countLimit := 0.
	savedCount :=0.
	logger := LWLogger new.
	
]

{ #category : #accessing }
LWServerContext >> logger [

	^ logger
]

{ #category : #accessing }
LWServerContext >> logger: anObject [

	logger := anObject
]

{ #category : #persistence }
LWServerContext >> persistObservation: obsevarion [

	| sessionTemp |
	sessionTemp := self session.
	sessionTemp inUnitOfWorkDo: [ sessionTemp register: obsevarion ].
	savedCount := savedCount +1.
	^savedCount 
]

{ #category : #filtering }
LWServerContext >> saveObservation: anObservation [

	(self hasSeen: anObservation) ifTrue: [ 
		logger
			logEvent: 'duplicate '
			aTime: anObservation timeStr
			aCount: buffer size.
		^ self ].
	buffer addObservation: anObservation.
	self persistObservation: anObservation.
	logger
		logEvent: '    saved '
		aTime: anObservation timeStr
		aCount: buffer size.
	^self
]

{ #category : #accessing }
LWServerContext >> savedCount [

	^ savedCount 
]

{ #category : #accessing }
LWServerContext >> savedCount: anObject [

	savedCount  := anObject
]

{ #category : #accessing }
LWServerContext >> session [

	 session ifNil: [  session :=  sessionFactory createSession: self sessionType ].
	session isLoggedIn ifFalse: [ session login ].
	^session. 
]

{ #category : #accessing }
LWServerContext >> session: anObject [

	session := anObject
]

{ #category : #accessing }
LWServerContext >> sessionFactory [

	^ sessionFactory
]

{ #category : #accessing }
LWServerContext >> sessionFactory: anObject [

	sessionFactory := anObject
]

{ #category : #accessing }
LWServerContext >> sessionType [

	^ sessionType
]

{ #category : #accessing }
LWServerContext >> sessionType: anObject [

	sessionType := anObject
]
