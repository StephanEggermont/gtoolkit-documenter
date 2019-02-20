Class {
	#name : #GtDocument,
	#superclass : #Object,
	#traits : 'TBlDebug + TGtAnnouncer + TGt2DocumentConstants',
	#classTraits : 'TBlDebug classTrait + TGtAnnouncer classTrait + TGt2DocumentConstants classTrait',
	#instVars : [
		'editor',
		'announcer',
		'cache',
		'isSubscribedToSystem',
		'variableBindings',
		'storageStrategy',
		'styleTextProcess',
		'pillarParser'
	],
	#category : #'GToolkit-Documenter-Model'
}

{ #category : #accessing }
GtDocument class >> constants [
	^ GtDocumentConstants
]

{ #category : #'instance creation' }
GtDocument class >> forClass: aClass [
	^ self new classComment: aClass; read
]

{ #category : #'instance creation' }
GtDocument class >> forFile: aFileReference [
	^ self new fileReference: aFileReference; read
]

{ #category : #announcer }
GtDocument >> announcer [
	<return: #Announcer>
	self subscribeToSystem.
	^ announcer
]

{ #category : #converting }
GtDocument >> asElement [
	<return: #BlElement>
	| anElement aToolbar |
	anElement := self asElementWithoutSaveAction.
	aToolbar := BlElement new 
			layout: BlLinearLayout horizontal;
			constraintsDo: [ :c | 
				c ignoreByLayout.
				c vertical fitContent.
				c horizontal fitContent.
				c ignored horizontal alignLeft.
				c ignored vertical alignBottom ].
	self gtActions do: [ :eachAction | 
		(eachAction target isForViewDefinedIn: #gtTextFor:) ifTrue: [ 
			eachAction 
				asElement: [ :anActionElement | aToolbar addChild: anActionElement ]
				withHostElement: anElement ] ].
	anElement addChild: aToolbar.
	^ anElement
]

{ #category : #converting }
GtDocument >> asElementWithoutSaveAction [
	<return: #BlElement>
	| anElement anEditorElement |
	anEditorElement := BrEditorElement new
			editor: self editor;
			constraintsDo: [ :c |
				c padding: (BlInsets all: 10).
				c vertical matchParent.
				c horizontal matchParent ].
	anElement := GtSceneInformingElement new
		layout: BlLinearLayout new;
		addChild: anEditorElement;
		addEventHandler: (GtAddedToSceneEventHandler new document: self);
		addEventHandler: (GtRemovedFromSceneEventHandler new document: self);
		constraintsDo: [ :c |
			c vertical matchParent.
			c horizontal matchParent ].
	anElement userData at: self constants documentUserDataKey put: self.
	self installCompleterForEditorElement: anEditorElement.
	^ anElement
]

{ #category : #accessing }
GtDocument >> basename [
	<return: #String>
	^ self storage basename
]

{ #category : #cache }
GtDocument >> cache [
	"It is not recommended to use this method outside of this object.
	You should use #cachAt:... relevant methods."
	<return: #Dictionary>
	^ cache
]

{ #category : #cache }
GtDocument >> cacheAt: aKey ifPresent: aPresentBlock ifAbsent: anAbsentBlock [
	^ cache at: aKey ifPresent: aPresentBlock ifAbsent: anAbsentBlock
]

{ #category : #cache }
GtDocument >> cacheAt: aKey ifPresent: aPresentBlock ifAbsentPut: anAbsentBlock [
	^ cache at: aKey ifPresent: aPresentBlock ifAbsentPut: anAbsentBlock
]

{ #category : #initialization }
GtDocument >> classComment: aClass [ 
	self 
		assert: [ aClass notNil ]
		description: [ 'Class to document must be non-nil' ].
	self strategy: (GtStorageStrategy classComment: aClass)
]

{ #category : #accessing }
GtDocument >> constants [
	^ GtDocumentConstants
]

{ #category : #initialization }
GtDocument >> defaultStyler [
	^ GtStyler new 
		document: self; 
		parser: self pillarParser;
		hideMarkup
]

{ #category : #initialization }
GtDocument >> defaultText [
	^ ''
]

{ #category : #initialization }
GtDocument >> displayMarkup [
	self editor styler mode isEditing ifTrue: [ ^ self ].
	self editor styler displayMarkup.
	self styleTextRequest.
]

{ #category : #accessing }
GtDocument >> editor [
	<return: #BrTextEditor>
	^ editor
]

{ #category : #private }
GtDocument >> ensureStyleTextProcess [
	styleTextProcess start
]

{ #category : #accessing }
GtDocument >> evaluationReceiver [
	"Return an object that is used as a receiver (self) in a codeblock (code snippet) evalution"
	<return: #Object>
	^ self storage evaluationReceiver
]

{ #category : #testing }
GtDocument >> exists [
	<return: #Boolean>
	^ self storage exists
]

{ #category : #initialization }
GtDocument >> fileReference: aFileReference [ 
	self 
		assert: [ aFileReference notNil ]
		description: [ 'Document file reference must be non-nil' ].
	self strategy: (GtStorageStrategy fileReference: aFileReference)
]

{ #category : #private }
GtDocument >> fileReferencesFrom: aCollectionOfStringsOrPaths referencedIn: aRootDirectory [
	<return: #Set of: #FileReference>
	^ aCollectionOfStringsOrPaths 
		collect: [ :eachStringOrPath | | fileReference |
			eachStringOrPath isString 
				ifTrue: [ fileReference := aRootDirectory resolveString: eachStringOrPath ]
				ifFalse: [ fileReference := aRootDirectory resolve: eachStringOrPath ].
			fileReference exists ifFalse: nil ifTrue: [ fileReference ] ]
		thenSelect: #notNil
]

{ #category : #'gt-extension' }
GtDocument >> gtResourcesFor: aView [
	<gtView>
	^ aView mondrian
		title: 'Resources';
		priority: 10;
		painting: [ :aMondrian | 
			| aResource |
			aResource := self resourcer includeDocuments; allDepth; get.
			aMondrian nodes 
				stencil: [ :eachResource | 
					| anElement |
					eachResource isDocument ifTrue: [ 
						anElement := BrCard new
							size: 200@100;
							look: BrShadowLook + BrLabelLook + BrDescriptionLook 
								+ BrGlamorousWithVerticalResizerLook + BrGlamorousWithHorizontalResizerLook;
							margin: (BlInsets all: 10);
							padding: (BlInsets all: 10);
							background: Color white;
							title: (eachResource document name asRopedText bold);
							description: ((eachResource document text asString 
									first: (100 min: eachResource document text size))
								asRopedText foreground: Color gray);
							action: [ :aBrCard | aBrCard			 
								 fireEvent: (GtPhlowObjectToSpawn new
									object: eachResource;
									sourceElement: aBrCard) ].
						 ]];
				with: aResource withAllResources.
			aMondrian edges 
				fromRightCenter;
				toLeftCenter;
				connectToAll: #resources.
			aMondrian layout custom: (GtGradHorizontalDominanceCenteredTreeLayout new 
				levelDistance: 50; nodeDistance: 10) ] 
]

{ #category : #'gt-extension' }
GtDocument >> gtSaveActionFor: anAction [
	<gtAction>
	^ anAction button
		icon: self constants saveButtonIcon asElement;
		forViewDefinedIn: #gtTextFor:;
		priority: 1;
		action: [ self store ]
]

{ #category : #'gt-extension' }
GtDocument >> gtShowMarkupActionFor: anAction [
	<gtAction>
	^ anAction toggle
		icon: self constants editButtonIcon;
		forViewDefinedIn: #gtTextFor:;
		priority: 3;
		activatedAction: [ self displayMarkup ];
		deactivatedAction: [ self hideMarkup ]
]

{ #category : #'gt-extension' }
GtDocument >> gtTextFor: aView [
	<gtView>
	self editor ifNil: [ ^ aView empty ].
	^ aView explicit
		title: 'Document';
		priority: 1;
		stencil: [ self asElementWithoutSaveAction ];
		actionButtonIcon: BrGlamorousIcons tree 
			action: [ :aWidget | 
				aWidget fireEvent: (GtPhlowObjectToSpawn new
					object: self parse;
					sourceElement: aWidget) ]
]

{ #category : #'announcement handling' }
GtDocument >> handleSystemChangeAnnouncement: aSystemAnnouncement [
	announcer announce: aSystemAnnouncement
]

{ #category : #testing }
GtDocument >> hasDocumentSubscriptions [
	^ announcer numberOfSubscriptions isZero not
]

{ #category : #initialization }
GtDocument >> hideMarkup [
	self editor styler mode isReading ifTrue: [ ^ self ].
	self editor styler hideMarkup.
	self styleTextRequest
]

{ #category : #initialization }
GtDocument >> initialize [
	super initialize.
	styleTextProcess := GtStyleTextProcess new document: self.
	announcer := Announcer new.
	isSubscribedToSystem := false.
	variableBindings := GtSnippetBindings new.
	cache := Dictionary new.
	editor := BrTextEditor new.
	editor styler: self defaultStyler.
	self text: self defaultText.
	storageStrategy := GtStorageStrategy null.
	self subscribeToEditorChanges.
]

{ #category : #private }
GtDocument >> installCompleterForEditorElement: anEditorElement [
	| aCompletionStrategy aCompletionController |
	aCompletionStrategy := GtDocumentCompletionStrategy new.
	aCompletionStrategy fileReference: self rootDirectory.
	aCompletionController := GtCompletionController on: anEditorElement strategy: aCompletionStrategy.
	aCompletionController install.

]

{ #category : #testing }
GtDocument >> isReadingMode [
	^ self editor styler mode isReading
]

{ #category : #testing }
GtDocument >> isSubscribedToSystem [
	^ isSubscribedToSystem
]

{ #category : #subscriptions }
GtDocument >> mayRequestDocumentUpdate [
	self isSubscribedToSystem ifFalse: [ ^ self ].
	self hasDocumentSubscriptions ifFalse: [ ^ self ].
	self styleTextRequest.
	self announcer announce: (GtDocumentUpdateRequestedAnnouncement new document: self)
]

{ #category : #subscriptions }
GtDocument >> maySubscribeToSystem [
	self hasDocumentSubscriptions ifFalse: [ ^ self ].
	self subscribeToSystem
]

{ #category : #subscriptions }
GtDocument >> mayUnsubscribeFromSystem [
	self hasDocumentSubscriptions ifTrue: [ ^ self ].
	self unsubscribeFromSystem
]

{ #category : #accessing }
GtDocument >> name [
	<return: #String>
	^ self storage name
]

{ #category : #actions }
GtDocument >> parse [
	"Message #isPetit2Failure helps to distinguish between a parsed document or a parser error"
	<return: #PRDocument or: #PP2Failure>
	^ PRValidation beSilentDuring: [ 
		self pillarParser parse: self string ].
]

{ #category : #utility }
GtDocument >> pillarParser [
	<return: #PRPillarParser>
	^ pillarParser ifNil: [ 
		pillarParser := PRPillarParser new optimize ]
]

{ #category : #private }
GtDocument >> privateStyleText [
	"This method is used only for examples.
	Do not use it in other places."
	self editor styleText
]

{ #category : #actions }
GtDocument >> read [
	storageStrategy read: self
]

{ #category : #utility }
GtDocument >> resourcer [
	^ GtResourceVisitor new document: self
]

{ #category : #accessing }
GtDocument >> rootDirectory [
	"Return root directory to access external data, e.g., images, change files"
	<return: #FileReference>
	^ self storage rootDirectory
]

{ #category : #accessing }
GtDocument >> storage [
	<return: #GtStorageStrategy>
	^ storageStrategy
]

{ #category : #actions }
GtDocument >> store [
	storageStrategy store: self
]

{ #category : #initialization }
GtDocument >> strategy: aGt2StorageStrategy [ 
	self 
		assert: [ aGt2StorageStrategy notNil ]
		description: [ 'Storage strategy must be non-nil' ].
	storageStrategy := aGt2StorageStrategy
]

{ #category : #accessing }
GtDocument >> string [
	<return: #String>
	^ self text asString
]

{ #category : #actions }
GtDocument >> styleTextRequest [
	styleTextProcess request.
]

{ #category : #subscriptions }
GtDocument >> subscribeToEditorChanges [
]

{ #category : #subscriptions }
GtDocument >> subscribeToSystem [
	self isSubscribedToSystem ifTrue: [ ^ self ].
	SystemAnnouncer uniqueInstance weak 
		subscribe: SystemAnnouncement
		send: #handleSystemChangeAnnouncement:
		to: self.
	isSubscribedToSystem := true.
]

{ #category : #accessing }
GtDocument >> text [
	<return: #BlText>
	^ self editor text
]

{ #category : #accessing }
GtDocument >> text: aStringOrRope [
	self 
		assert: [ aStringOrRope notNil ] 
		description: [ 'The document text must be non-nil (a string or a rope)' ].
	editor text: aStringOrRope asRopedText.
]

{ #category : #'announcer - subscription' }
GtDocument >> unsubscribe: anObject [
	"Unsubscribe all subscriptions of anObject from the receiver"
	| theRemovedSubscriptions |
	theRemovedSubscriptions := self announcer unsubscribe: anObject.
	self mayUnsubscribeFromSystem.
	^ theRemovedSubscriptions
]

{ #category : #subscriptions }
GtDocument >> unsubscribeFromSystem [
	self isSubscribedToSystem ifFalse: [ ^ self ].
	SystemAnnouncer uniqueInstance unsubscribe: self.
	isSubscribedToSystem := false.
]

{ #category : #subscriptions }
GtDocument >> updateAndSubscribeToSystem [
	self 
		maySubscribeToSystem;
		mayRequestDocumentUpdate
]

{ #category : #accessing }
GtDocument >> variableBindings [
	^ variableBindings
]

{ #category : #accessing }
GtDocument >> variableBindings: anObject [
	variableBindings := anObject
]