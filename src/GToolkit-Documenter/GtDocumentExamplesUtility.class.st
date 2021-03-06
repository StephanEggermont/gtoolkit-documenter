"
I am used by ${class:GtDocumentExamples}$.
"
Class {
	#name : #GtDocumentExamplesUtility,
	#superclass : #Object,
	#traits : 'TGtDocumentConstants + TBlDebug',
	#classTraits : 'TGtDocumentConstants classTrait + TBlDebug classTrait',
	#category : #'GToolkit-Documenter-Examples'
}

{ #category : #accessing }
GtDocumentExamplesUtility class >> constants [
	^ GtDocumentConstants
]

{ #category : #'api - text' }
GtDocumentExamplesUtility class >> deleteText: aBlRope from: aFromIndex to: aToIndex [ 
	aBlRope delete: aFromIndex to: aToIndex
]

{ #category : #'api - text' }
GtDocumentExamplesUtility class >> insertText: anInsertingBlRope at: anIndex in: anEditedBlRope [ 
	anEditedBlRope insertText: anInsertingBlRope at: anIndex
]

{ #category : #accessing }
GtDocumentExamplesUtility >> constants [
	^ GtDocumentConstants
]
