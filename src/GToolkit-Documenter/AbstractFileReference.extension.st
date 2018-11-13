Extension { #name : #AbstractFileReference }

{ #category : #'*GToolkit-Documenter' }
AbstractFileReference >> parseWithGtDocumenter [
	| encoding |
	encoding := [ self binaryReadStreamDo: [ :in | (ZnCharacterEncoder detectEncoding: in upToEnd) identifier ] ]
		on: ZnCharacterEncodingError
		do: [ nil ].
	^ self binaryReadStreamDo: [ :in | 
		PRPillarParser new optimize parse: (ZnCharacterReadStream on: in encoding: encoding) upToEnd ]
]