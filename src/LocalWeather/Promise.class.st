"
promise
        ^ self promiseAt: Processor userBackgroundPriority.

promiseAt: aPriority
        ""Answer a promise that represents the result of the receiver
           execution
        at the given priority.""
        | promise |
        promise := Promise new.
        [ promise value: self value ] forkAt: aPriority.
        ^ promise
"
Class {
	#name : #Promise,
	#superclass : #Object,
	#instVars : [
		'valueProtectingSemaphore',
		'value',
		'hasValue'
	],
	#category : #LocalWeather
}

{ #category : #accessing }
Promise >> hasValue [
        ^ hasValue

]

{ #category : #initialization }
Promise >> initialize [
        super initialize.
        valueProtectingSemaphore := Semaphore new.
        hasValue := false
]

{ #category : #accessing }
Promise >> value [

	valueProtectingSemaphore wait.
	valueProtectingSemaphore signal. 
	^ value
]

{ #category : #accessing }
Promise >> value: resultValue [

	value := resultValue.
	hasValue := true.
	valueProtectingSemaphore signal
]
