Class {
	#name : #LWObservationTest,
	#superclass : #TestCase,
	#category : #'LocalWeather-Test'
}

{ #category : #tests }
LWObservationTest >> testDeserialize [ 

	| msg obs |
	msg := '{"time" : "2023-03-18 11:28:38.421956", "protocol" : 40, "model" : 	"Acurite-5n1", "message_type" : 49, "id" : 1079, "channel" : "C", "sequence_num" : 2, "battery_ok" : 1, "wind_avg_km_h" : 6.795, "wind_dir_deg" : 337.500, "rain_in" : 12.720, "mic" : "CHECKSUM", "mod" : "ASK", "freq" : 433.931, "rssi" : -5.494, "snr" : 28.319, "noise" : -33.813}'.
		
	obs := NeoJSONReader fromString: msg as: LWObservation .
	self assert: obs messageType equals: 49.
	self assert: obs batteryOk  equals: 1.
	self assert: obs humidity equals: nil. 
	self assert: obs rainIn equals: 12.720.
	self assert: (obs rain) equals: ((12.720 * 25.4) asFloat roundTo: 0.001).
]

{ #category : #tests }
LWObservationTest >> testIsValidObservation [

	| observation |
	
	observation := LWObservation new. 
	observation model: 'xyzzy'.
	self assert: observation isValidObsevation  equals: false. 
	observation model: 'Acurite-5n1'.
	self assert: observation isValidObsevation equals: true. 

]

{ #category : #tests }
LWObservationTest >> testTemperature [
	| tempF |
	
	tempF := LWObservation new. 
	tempF temperatureF: 32. 
	self assert: tempF temperature equals: 0.
	self assert: tempF temperatureC equals: 0.
	self assert: tempF temperatureF equals: 32.
	
	tempF temperatureC: 100. 
	self assert: tempF temperature equals: 100.
	self assert: tempF temperatureC equals: 100.
	self assert: tempF temperatureF equals: 212.

]
