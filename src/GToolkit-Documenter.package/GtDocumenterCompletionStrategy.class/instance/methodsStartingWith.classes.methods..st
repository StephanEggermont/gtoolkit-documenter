private
methodsStartingWith: aString classes: classesTree methods: methodBlock
	| index spaceIndex class name prefix |
	index := aString indexOfSubCollection: '>>#'.
	index > 0
		ifTrue: [ name := aString copyFrom: 1 to: index - 1.
			spaceIndex := name indexOf: $  ifAbsent: [ name size + 1 ].
			class := Smalltalk at: (name copyFrom: 1 to: spaceIndex - 1) asSymbol ifAbsent: [ ^ #() ].
			(name includes: $ )
				ifTrue: [ class := class class ].
			prefix := aString allButFirst: index + 2.
			^ ((methodBlock value: class) first: max startingWith: prefix)
				collect: [ :each | 
					self
						complete: each
						with: (each allButFirst: prefix size)
						deleting: 0
						at: position
						prefixSize: prefix size ] ].
	^ (classesTree first: max startingWith: aString)
		collect: [ :each | 
			| action |
			action := self
				complete: each
				with: (each allButFirst: aString size) , '>>#'
				deleting: 0
				at: position
				prefixSize: aString size.
			action partial: true.
			action ]