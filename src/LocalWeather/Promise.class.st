"
For the Class part:  The promise that a block closure will deliver a value in the future. 

For the Responsibility part: Hold the forked block closure and keepe track of when the  block has returend a value. Decouple an asynchronus process from the code flow. 

For the Collaborators Part: Anyone who's going to execute a request and have to wait for the results.. 

Public API and Key Messages

- hasValue returns false until the block clousure has completed and returend a value.   
- value  the value returned by the block closure. This method will block if a value hasn't been returned by the block
- promise := [ 1+2]promise.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	hasValue  boolean 
	value:		value returned by the block
	valueProtectingSemaphore:		blocking semaphore that is used to wait for the result. 


    Implementation Points

This code is not enough you have to add two methods to BlockClousre

BlockClosure >> promise
        ^ self promiseAt: Processor activePriority


BlockClosure >> promiseAt: aPriority
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
