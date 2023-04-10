"
Class:  LWObservation an weather observation from the acurite 5-n-1 weather station.

Responsibility: Holds the data sent from the stataion through a MMQT broker as a JSON packet. 

Collaborators: LWServer reads the data fom the MQTT broker converts it to an Object 
and then sends it to the database. 

Public API and Key Messages


- message - the JSON message from the MQTT broker
   
- (for bonus points) how to create instances.

   NeoJSONReader fromString: as: LWObservation
 
Internal Representation and Key Implementation Points.

    Instance Variables
	batteryOk:		battery level station
	humidity:	 measurement 
	id:		db key
	message:		JSON value from broker
	messageType:		56 or 49
	model:		accurite-5n1
	rain:		in mm
	temperature:		degress celcius
	time:		of Observation
	timeStr:		time as a sring
	windAvgKmHour:		wind speed
	windDirDeg:		wind direction


    Implementation Points
"
Class {
	#name : #LWObservation,
	#superclass : #Object,
	#instVars : [
		'id',
		'messageType',
		'time',
		'batteryOk',
		'windDirDeg',
		'windAvgKmHour',
		'rain',
		'temperature',
		'humidity',
		'timeStr',
		'message',
		'model'
	],
	#category : #LocalWeather
}

{ #category : #accessing }
LWObservation class >> neoJsonMapping: mapper [

"windDirDeg messageType time batteryOk rainIn windAvgKmHour"

	mapper for: self do: [ :mapping |
		mapping mapInstVar: #messageType to: 'message_type'.
		mapping mapAccessor:  #timeStr to: 'time'.
		mapping mapInstVar: #batteryOk to: 'battery_ok'.
		mapping mapInstVar: #windDirDeg to: 'wind_dir_deg'.
		mapping mapAccessor: #rainMm to: 'rain_mm'.
		mapping mapAccessor: #rainIn to: 'rain_in'.
		mapping mapInstVar: #windAvgKmHour to: 'wind_avg_km_h'.
		mapping mapAccessor: #temperatureC to: 'temperature_C'.
		mapping mapAccessor: #temperatureF to: 'temperature_F'.
		mapping mapInstVar: #humidity to: 'humidity'.
		mapping mapInstVar: #model to: 'model'.
		
	]
]

{ #category : #'as yet unclassified' }
LWObservation class >> observationBlock [
	

^ [ | client result | 
	client := MQTTClient new.
	client
		host: '192.168.0.232';
		keepalive: 60;
		timeout: 60.
	client open. 
   result :=  [
		client	subscribeToTopic: 'weather/accurite'.
		client readMessage ] ensure: [client close]. 
	result ifNotNil: [ result message asString ]
]
]

{ #category : #comparing }
LWObservation >> = otherObject [

	^(otherObject class = self class )
		and: ((otherObject time = self time)
			and: otherObject messageType = self messageType)
		
]

{ #category : #accessing }
LWObservation >> batteryOk [

	^ batteryOk
]

{ #category : #accessing }
LWObservation >> batteryOk: anObject [

	batteryOk := anObject
]

{ #category : #comparing }
LWObservation >> hash [ 
	^ time hash bitXor: messageType hash
]

{ #category : #accessing }
LWObservation >> humidity [

	^ humidity
]

{ #category : #accessing }
LWObservation >> humidity: anObject [

	humidity := anObject
]

{ #category : #accessing }
LWObservation >> id [

	^ id
]

{ #category : #accessing }
LWObservation >> id: anObject [

	id := anObject
]

{ #category : #accessing }
LWObservation >> isValidObsevation [

		^self model = 'Acurite-5n1'
]

{ #category : #accessing }
LWObservation >> message [

	^ message
]

{ #category : #accessing }
LWObservation >> message: anObject [

	message := anObject
]

{ #category : #accessing }
LWObservation >> messageType [

	^ messageType
]

{ #category : #accessing }
LWObservation >> messageType: anObject [

	messageType := anObject
]

{ #category : #accessing }
LWObservation >> model [

	^ model
]

{ #category : #accessing }
LWObservation >> model: anObject [

	model := anObject
]

{ #category : #accessing }
LWObservation >> rain [ 
	
	^(rain asFloat roundTo: 0.001)
]

{ #category : #accessing }
LWObservation >> rain: anObject [

	rain := (anObject asFloat) roundTo: 0.001.
]

{ #category : #accessing }
LWObservation >> rainIn [

	^ rain / 25.4 asFloat roundTo: 0.001
]

{ #category : #accessing }
LWObservation >> rainIn: aNumber [

	rain := (aNumber *25.4) roundTo: 0.001.

]

{ #category : #accessing }
LWObservation >> rainMm [

	^ rain
]

{ #category : #accessing }
LWObservation >> rainMm: aFloat [


	^rain  := aFloat.
]

{ #category : #accessing }
LWObservation >> temperature [

	^temperature
]

{ #category : #accessing }
LWObservation >> temperature: anObject [

	temperature := anObject.

]

{ #category : #accessing }
LWObservation >> temperatureC [

	^temperature 

]

{ #category : #accessing }
LWObservation >> temperatureC: anObject [

	temperature := anObject.

]

{ #category : #accessing }
LWObservation >> temperatureF [

	^((temperature * 9/5) + 32) asFloat roundTo: 0.01
]

{ #category : #accessing }
LWObservation >> temperatureF: anObject [
	temperature := ((anObject - 32) * 5/9) asFloat roundTo: 0.01 
]

{ #category : #accessing }
LWObservation >> time [

	^time

]

{ #category : #accessing }
LWObservation >> time: anObject [

	time := anObject
]

{ #category : #accessing }
LWObservation >> timeStr [

	^ timeStr
]

{ #category : #accessing }
LWObservation >> timeStr1: anObject [

	timeStr := anObject
]

{ #category : #accessing }
LWObservation >> timeStr: anObject [

	| stream date timeTmp |
	anObject ifNotNil: [ 
   		stream := anObject  readStream.
   		date := Date readFrom: (stream upTo: $ ) readStream pattern: 'yyyy-m-dd'.
   		timeTmp := Time readFrom: stream.
   		self time: (DateAndTime date: date time: timeTmp).
	].
	timeStr := anObject
]

{ #category : #accessing }
LWObservation >> windAvgKmHour [

	^ windAvgKmHour
]

{ #category : #accessing }
LWObservation >> windAvgKmHour: anObject [

	windAvgKmHour := anObject
]

{ #category : #accessing }
LWObservation >> windDirDeg [

	^ windDirDeg
]

{ #category : #accessing }
LWObservation >> windDirDeg: anObject [

	windDirDeg := anObject
]
