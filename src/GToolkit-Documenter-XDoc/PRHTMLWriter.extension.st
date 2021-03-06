Extension { #name : #PRHTMLWriter }

{ #category : #'*GToolkit-Documenter-XDoc' }
PRHTMLWriter >> gtWriteExampleCode: aGt2ExampleAnnotation [ 
	canvas tag
		name: 'figure';
		parameterAt: 'class' put: 'codeBlock gtexample-src';
		with: [ 
					canvas tag
						name: 'pre';
						with: [ 
									| code language |
									code := canvas tag
										name: 'code';
										yourself.
									language := PRSmalltalkScriptLanguage default.
									language isSyntaxHighlightingPossible
										ifTrue: [ code parameterAt: 'class' put: language printString ].
									code with: [ aGt2ExampleAnnotation isMethodDefined 
										ifTrue: [ canvas lines: aGt2ExampleAnnotation methodDefinition sourceCode ]
										ifFalse: [ canvas lines: aGt2ExampleAnnotation methodDefinition printString ] ] ].
					canvas tag
						name: 'figcaption';
						with: [ 
									aGt2ExampleAnnotation hasLabel
										ifTrue: [ 
											self createAnchorWith: aGt2ExampleAnnotation label.
											self writeCounterForScript: aGt2ExampleAnnotation ].
									aGt2ExampleAnnotation hasCaption
										ifTrue: [ self visitAll: aGt2ExampleAnnotation caption children ] ] ].
	canvas newLine
]

{ #category : #'*GToolkit-Documenter-XDoc' }
PRHTMLWriter >> gtWriteExampleResult: aGt2ExampleAnnotation [ 
	| aFigure aFigureReference |
	aFigure := PRFigure new.
	aFigure label: 'figure-' , aGt2ExampleAnnotation methodName.
	aFigure add: (PRText content: 'Result of ' , aGt2ExampleAnnotation methodName).
	aFigureReference := self configuration gtDataWriter exampleResultReferenceFor: aGt2ExampleAnnotation.
	aFigure reference: aFigureReference.
	aGt2ExampleAnnotation parameters at: #previewHeight ifPresent: [:value | aFigure parameterAt: #height put: value].
	self visitFigure: aFigure.
]

{ #category : #'*GToolkit-Documenter-XDoc' }
PRHTMLWriter >> gtWriteSourceCodeForEntity: anEntityName with: aSourceCode [

	| uniqueId language code |
	uniqueId := 	self configuration gtUniqueIdGenerator next printString.
	aSourceCode 
		ifNil: [ 
			canvas tag
				name: 'span';
				with: [ canvas nextPutAll: anEntityName ].
		 ];
		ifNotNil: [ 
			canvas tag
				name: 'span';
				parameterAt: 'class' put: 'sourceCode';
				with: [ 
					canvas tag
						name: 'a';
						with: [ canvas nextPutAll: anEntityName ].
						canvas tag
							name: 'span';
							parameterAt: 'id' put: uniqueId;
							parameterAt: 'class' put: 'codeBlock';
							with: [
								language := PRSmalltalkScriptLanguage default.
								code := canvas tag
									name: 'code';
									yourself.
								language := PRSmalltalkScriptLanguage default.
								language isSyntaxHighlightingPossible
									ifTrue: [ code parameterAt: 'class' put: language printString ].
								code with: [ 
									canvas newLine.
									canvas lines: aSourceCode.
									canvas newLine.
								].
							].
					].
		 ].
]

{ #category : #'*GToolkit-Documenter-XDoc' }
PRHTMLWriter >> visitGt2ChangesAnnotation: aGt2ChangesAnnotation [
	| aContent language code |
	aGt2ChangesAnnotation gtDocument: self configuration gtDocument.
	aContent := aGt2ChangesAnnotation cachedChanges tutorialStateRope asString.
	canvas tag
		name: 'div';
		parameterAt: 'class' put: 'codeBlock changes';
		with: [ 
			language := PRSmalltalkScriptLanguage default.						
			canvas tag
				name: 'pre';
				with: [
					code := canvas tag
						name: 'code';
						yourself.
					language := PRSmalltalkScriptLanguage default.
					language isSyntaxHighlightingPossible
						ifTrue: [ code parameterAt: 'class' put: language printString ].
					code with: [ 
						canvas lines: aContent
					].
				].
			].
	canvas newLine
]

{ #category : #'*GToolkit-Documenter-XDoc' }
PRHTMLWriter >> visitGt2ClassAnnotation: aGt2ClassAnnotation [
	^ self gtWriteSourceCodeForEntity: (aGt2ClassAnnotation referencedClass name) with: (aGt2ClassAnnotation referencedClass definition).
]

{ #category : #'*GToolkit-Documenter-XDoc' }
PRHTMLWriter >> visitGt2ExampleAnnotation: aGt2ExampleAnnotation [
	aGt2ExampleAnnotation gtDocument: self configuration gtDocument.
	aGt2ExampleAnnotation isMethodDefined ifFalse: [ ^ self ].
	aGt2ExampleAnnotation noCode ifFalse: [ self gtWriteExampleCode: aGt2ExampleAnnotation ].
	aGt2ExampleAnnotation canBeExecuted ifFalse: [ ^ self ].
	self gtWriteExampleResult: aGt2ExampleAnnotation.
]

{ #category : #'*GToolkit-Documenter-XDoc' }
PRHTMLWriter >> visitGt2ExamplesAnnotation: aGt2ExamplesAnnotation [
	self visitOrderedList: (PROrderedList withAll: (aGt2ExamplesAnnotation allExamples collect: [ :anExample | PRListItem with: (PRText content: anExample method name) ])).
	
]

{ #category : #'*GToolkit-Documenter-XDoc' }
PRHTMLWriter >> visitGt2IcebergFileAnnotation: aGt2IcebergFileAnnotation [ 
	| aHref |
	aGt2IcebergFileAnnotation isReferenceDefined ifFalse: [ ^ self ]. 
	aHref := GtResourcesUtilityConstants localGtDirectoryName, '/', aGt2IcebergFileAnnotation path.
	canvas tag
		name: 'a';
		parameterAt: 'href' put: aHref;
		with: [ canvas nextPutAll: aHref ].
]

{ #category : #'*GToolkit-Documenter-XDoc' }
PRHTMLWriter >> visitGt2MethodAnnotation: aGt2MethodAnnotation [	
	^ self gtWriteSourceCodeForEntity: (aGt2MethodAnnotation referencedMethod name) with: (aGt2MethodAnnotation referencedMethod sourceCode).
]

{ #category : #'*GToolkit-Documenter-XDoc' }
PRHTMLWriter >> visitGt2XDocsAnnotation: aGt2XDocsAnnotation [	
	| serverURL |
	serverURL := aGt2XDocsAnnotation client serverUrl asString.
	canvas tag
		name: 'a';
		parameterAt: 'href' put: serverURL;
		with: serverURL.
]
