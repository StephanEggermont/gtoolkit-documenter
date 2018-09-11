Class {
	#name : #GtFileSystemExamples,
	#superclass : #Object,
	#instVars : [
		'memory',
		'rootDirectoryName'
	],
	#category : 'GToolkit-Documenter-Examples'
}

{ #category : #utility }
GtFileSystemExamples >> addFileNamed: fileNameString toDirectory: rootDirectory withContent: aString [
	| rootDocument |
	rootDocument := (rootDirectory / fileNameString) 
		writeStreamDo: [ :aStream | 
			aStream nextPutAll: aString ];
		yourself.
	self assert: rootDocument exists.
	self assert: rootDocument contents size > 1.
	^ rootDocument
]

{ #category : #utility }
GtFileSystemExamples >> addFileNamed: fileNameString withContent: aString [
	^ self 
		addFileNamed: fileNameString 
		toDirectory: self rootDirectory 
		withContent: aString
]

{ #category : #utility }
GtFileSystemExamples >> addPillarFileWithContent: aString [
	^ self 
		addFileNamed: self pillarFileName 
		toDirectory: self rootDirectory 
		withContent: aString
]

{ #category : #'file system' }
GtFileSystemExamples >> basicMemorySystem [
	<gtExample>
	<label: 'Basic Memory File System'>
	memory ifNil: [
		 memory := FileSystem memory.
		"Only root '/' should be present"
		self assert: memory root allChildren size equals: 1 ].
	^ memory
]

{ #category : #'default file names' }
GtFileSystemExamples >> pillarFileName [
	<gtExample>
	<label: 'Pillar filename'>
	^ 'index.pillar'
]

{ #category : #accessing }
GtFileSystemExamples >> pillarFileReference [
	<gtExample>
	<label: 'FileReference with a Pillar content'>
	^ (self rootDirectory / self pillarFileName)
]

{ #category : #'file system' }
GtFileSystemExamples >> rootDirectory [
	<gtExample>
	<label: 'Working directory of a memory file system'>
	^ rootDirectoryName 
		ifNil: [ self basicMemorySystem workingDirectory ]
		ifNotNil: [ (self basicMemorySystem workingDirectory / rootDirectoryName)
			ensureCreateDirectory ]
]

{ #category : #accessing }
GtFileSystemExamples >> rootDirectoryName [
	<return: #String or: nil>
	^ rootDirectoryName
]

{ #category : #accessing }
GtFileSystemExamples >> rootDirectoryName: aString [
	self assert: aString isString description: 'The directory name has to be a string'.
	self 
		assert: [ (aString includes: self basicMemorySystem delimiter) not ]
		description: [ 'The directory name should not include ''', 
			self basicMemorySystem delimiter, ''' character' ].
	
	rootDirectoryName := aString
]