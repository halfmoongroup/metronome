Class {
	#name : #LWSessionManager,
	#superclass : #Object,
	#category : #LocalWeather
}

{ #category : #persistence }
LWSessionManager >> createDBSession [

	| login session |
	login := Login new
		         database: PostgreSQLPlatform new;
		         username: 'WeatherMgr';
		         password: 'password';
		         host: '192.168.0.232';
		         port: '5432';
		         databaseName: 'WeatherData'.
	session := LWObservationDescriptorSystem sessionForLogin: login.
	session login. 
	^session
]

{ #category : #accessing }
LWSessionManager >> createSession: type [

	(type = 'persistent') ifTrue: [ ^ self createDBSession  ].
	^ self createTestSession
]

{ #category : #'as yet unclassified' }
LWSessionManager >> createTestSession [

	^LWLocalSession new
]
