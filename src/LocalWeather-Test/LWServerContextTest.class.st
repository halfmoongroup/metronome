Class {
	#name : #LWServerContextTest,
	#superclass : #TestCase,
	#category : #'LocalWeather-Test'
}

{ #category : #tests }
LWServerContextTest >> testInitialized [

	|context | 
	context :=  LWServerContext new.
	self assert: context sessionType equals: 'persistent'
]

{ #category : #tests }
LWServerContextTest >> testPersistObservation [

	| context aSession |
	 
	context := LWServerContext new. 
	context sessionType: 'test'.
	aSession := context session.
	self assert: (aSession className) equals: 'LWLocalSession'.
	self assert: ((aSession linkedList) anySatisfy:  [ :each | each =2]) equals: false.
	context persistObservation: 2. 
	self assert: ((aSession linkedList) anySatisfy:  [ :each | each =2]) equals: true.
	self assert: ((aSession linkedList) anySatisfy:  [ :each | each =3]) equals: false.
]

{ #category : #tests }
LWServerContextTest >> testShouldContinue [
	| server |
	server := LWServerContext  new. 
	self assert: server captureComplete equals: false. 
	server savedCount: 100. 
	self assert: server captureComplete equals: false. 
	server countLimit:  50. 
	self assert: server captureComplete equals: true. 

]
