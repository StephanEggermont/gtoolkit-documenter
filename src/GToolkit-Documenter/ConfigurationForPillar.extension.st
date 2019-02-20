Extension { #name : #ConfigurationForPillar }

{ #category : #'*GToolkit-Documenter' }
ConfigurationForPillar >> gtDataWriter [
	<return: #XdExternalDataWriter>
	^ self propertyAt: #gtDataWriter ifAbsentPut: [ XdExternalDataWriter new ]
]

{ #category : #'*GToolkit-Documenter' }
ConfigurationForPillar >> gtDataWriter: aGt2ExternalDataWriter [ 
	^ self propertyAt: #gtDataWriter put: aGt2ExternalDataWriter
]

{ #category : #'*GToolkit-Documenter' }
ConfigurationForPillar >> gtDocument [
	<return: #GtDocument>
	^ self propertyAt: #gtDocument
]

{ #category : #'*GToolkit-Documenter' }
ConfigurationForPillar >> gtDocument: aGt2Document [
	^ self propertyAt: #gtDocument put: aGt2Document
]

{ #category : #'*GToolkit-Documenter' }
ConfigurationForPillar >> gtUniqueIdGenerator [
	<return: #XdUniqueIdGenerator>
	^ self propertyAt: #gtUniqueIdGenerator ifAbsentPut: [ XdUniqueIdGenerator new ]
]

{ #category : #'*GToolkit-Documenter' }
ConfigurationForPillar >> gtUniqueIdGenerator: aGt2UniqueIds [ 
	^ self propertyAt: #gtUniqueIdGenerator put: aGt2UniqueIds
]