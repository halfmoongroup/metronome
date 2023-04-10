Class {
	#name : #LWContext,
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
LWContext >> captureComplete [
	
	^(countLimit  ~= 0) 
	ifTrue: 
		[^ (savedCount > countLimit) ];
	ifFalse: 
		[ ^false ]

]

{ #category : #accessing }
LWContext >> countLimit [

	^ countLimit 
]

{ #category : #accessing }
LWContext >> countLimit: anNumber [

 	countLimit := anNumber
]

{ #category : #validation }
LWContext >> hasSeen: anObservation [

	 ^ buffer anySatisfy: [ :each | each = anObservation ]
]

{ #category : #initialization }
LWContext >> initialize [ 
	buffer :=  LWBuffer new. 
	sessionType := 'persistent'.
	sessionFactory := LWSessionManager  new. 
	countLimit := 0.
	savedCount :=0.
	logger := LWLogger new.
	
]

{ #category : #accessing }
LWContext >> logger [

	^ logger
]

{ #category : #accessing }
LWContext >> logger: anObject [

	logger := anObject
]

{ #category : #persistence }
LWContext >> persistObservation: obsevarion [

	| sessionTemp |
	sessionTemp := self session.
	sessionTemp inUnitOfWorkDo: [ sessionTemp register: obsevarion ].
	savedCount := savedCount +1.
	^savedCount 
]

{ #category : #filtering }
LWContext >> saveObservation: anObservation [

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
LWContext >> savedCount [

	^ savedCount 
]

{ #category : #accessing }
LWContext >> savedCount: anObject [

	savedCount  := anObject
]

{ #category : #accessing }
LWContext >> session [

	 session ifNil: [  session :=  sessionFactory createSession: self sessionType ].
	session isLoggedIn ifFalse: [ session login ].
	^session. 
]

{ #category : #accessing }
LWContext >> session: anObject [

	session := anObject
]

{ #category : #accessing }
LWContext >> sessionFactory [

	^ sessionFactory
]

{ #category : #accessing }
LWContext >> sessionFactory: anObject [

	sessionFactory := anObject
]

{ #category : #accessing }
LWContext >> sessionType [

	^ sessionType
]

{ #category : #accessing }
LWContext >> sessionType: anObject [

	sessionType := anObject
]
