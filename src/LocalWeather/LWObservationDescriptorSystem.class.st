"
Class part: Glorp description of what we're saving

Responsibility part: I describe the database table and the map between the object and the table. 
For the Collaborators Part: Used by GLORP to persist the local weather observation. 

Public API and Key Messages

- allTableName  descirbes the tables used because the table is mixed case  
- classModelForOBSERVATION  - describes the observation object and
= descriptionForLWObservation - 
- tableForOBSERVATIONS

- (for bonus points) how to create instances.
 no instances are created except by glorp

"
Class {
	#name : #LWObservationDescriptorSystem,
	#superclass : #DescriptorSystem,
	#category : #LocalWeather
}

{ #category : #accessing }
LWObservationDescriptorSystem >> allTableNames [
	^#('Observations')
]

{ #category : #model }
LWObservationDescriptorSystem >> classModelForLWObservation: aClassModel [

	aClassModel newAttributeNamed: #id.
	aClassModel newAttributeNamed: #messageType. 
	aClassModel newAttributeNamed: #time.
	aClassModel newAttributeNamed: #batteryOk.
	aClassModel newAttributeNamed: #windDirDeg.
	aClassModel newAttributeNamed: #windAvgKmHour. 
	aClassModel newAttributeNamed: #rain.
	aClassModel newAttributeNamed: #temperature.
	aClassModel newAttributeNamed: #humidity.
	aClassModel newAttributeNamed: #message.

]

{ #category : #model }
LWObservationDescriptorSystem >> descriptorForLWObservation: aDescriptor [
	"batteryOk humidity id time rain temperature windDirDeg windAvgKmHour messageType "
	| table |
	table := self tableNamed: 'Observations'.
	aDescriptor table: table.
	aDescriptor directMappingFor: #id.
	(aDescriptor newMapping: DirectMapping)
		from: #batteryOk
		to: (table fieldNamed: 'batterystatus').
	(aDescriptor newMapping: DirectMapping)
		from: #humidity
		to: (table fieldNamed: 'humidity').
	(aDescriptor newMapping: DirectMapping)
		from: #time
		to: (table fieldNamed: 'observationdate').
	(aDescriptor newMapping: DirectMapping)
		from: #rain
		to: (table fieldNamed: 'percipitation').
	(aDescriptor newMapping: DirectMapping)
		from: #temperature
		to: (table fieldNamed: 'temperature').
	(aDescriptor newMapping: DirectMapping)
		from: #windDirDeg
		to: (table fieldNamed: 'wind_direction').
	(aDescriptor newMapping: DirectMapping)
		from: #windAvgKmHour
		to: (table fieldNamed: 'wind_speed').
	(aDescriptor newMapping: DirectMapping)
		from: #messageType
		to: (table fieldNamed: 'messageType').
	(aDescriptor newMapping: DirectMapping)
		from: #message
		to: (table fieldNamed: 'message').
]

{ #category : #model }
LWObservationDescriptorSystem >> tableForOBSERVATIONS: aTable [

	(aTable createFieldNamed: 'id' type: platform serial) bePrimaryKey.
	aTable createFieldNamed: 'batterystatus' type: (platform int).
	aTable createFieldNamed: 'humidity' type: (platform float).	
	aTable createFieldNamed: 'observationdate' type: (platform dateAndTime).
	aTable createFieldNamed: 'percipitation' type: (platform float).
	aTable createFieldNamed: 'temperature' type: (platform float).
	aTable createFieldNamed: 'wind_speed' type: (platform float).	
	aTable createFieldNamed: 'wind_direction' type: (platform float).
	aTable createFieldNamed: 'messageType' type: (platform int).
	aTable createFieldNamed: 'message' type: (platform varchar: 1024).

]
