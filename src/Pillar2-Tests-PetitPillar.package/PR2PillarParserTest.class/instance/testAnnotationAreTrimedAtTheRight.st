tests - Annotation
testAnnotationAreTrimedAtTheRight
	super testAnnotationAreTrimedAtTheRight.
	self
		assert: result
		equals:
			(PRInputFileAnnotation
				withParametersInCollection:
					(OrderedDictionary new
						at: 'path' put: 'Foo';
						yourself)).
	self assertStart: 1 stop: 22.