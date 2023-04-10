Class {
	#name : #PromiseTest,
	#superclass : #TestCase,
	#category : #'LocalWeather-Test'
}

{ #category : #tests }
PromiseTest >> testPromise [

	| promise |
	promise := [ 1 + 2 ] promise.
	self assert: promise value equals: 3
]

{ #category : #tests }
PromiseTest >> testPromiseBlockingAndUnblocking [

	| controllingPromiseSemaphore promise |
	controllingPromiseSemaphore := Semaphore new.
	[ 
	(Delay forSeconds: 2) wait.
	controllingPromiseSemaphore signal ] fork.
	promise := [ 
	           controllingPromiseSemaphore wait.
	           1 + 3 ] promise.
	self deny: promise hasValue.
	controllingPromiseSemaphore signal. 
	(Delay forMilliseconds:  250) wait.
	self assert: promise hasValue equals: true.
	self assert: promise value equals: 4
]

{ #category : #tests }
PromiseTest >> testPromiseCreation [

	| promise |
	promise := [ 1 + 2 ] promise.
	self deny: promise hasValue.
	self deny: promise equals: 3
]
