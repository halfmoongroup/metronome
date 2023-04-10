"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestLocalWeather,
	#superclass : #PackageManifest,
	#category : #LocalWeather
}

{ #category : #'code-critics' }
ManifestLocalWeather class >> ruleCodeCruftLeftInMethodsRuleV1FalsePositive [
	^ #(#(#(#RGClassDefinition #(#LWServer)) #'2023-03-28T08:53:34.856103-04:00') )
]

{ #category : #'code-critics' }
ManifestLocalWeather class >> ruleUnclassifiedMethodsRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#ReadData #getData #false)) #'2023-04-07T14:17:50.136099-04:00') )
]
