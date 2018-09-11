Class {
	#name : #BaselineOfGToolkitDocumenter,
	#superclass : #BaselineOf,
	#category : 'BaselineOfGToolkitDocumenter'
}

{ #category : #baseline }
BaselineOfGToolkitDocumenter >> baseline: spec [
	<baseline>
	spec for: #common do: [ 
		spec
			baseline: 'Brick' with: [ spec
				repository: 'github://pharo-graphics/Brick/src' ];
			baseline: 'GToolkitCompleter' with: [ spec
				repository: 'github://feenkcom/gtoolkit-completer/src' ];
			baseline: 'GToolkitUtility' with: [ spec 
				repository: 'github://feenkcom/gtoolkit/src' ];
			baseline: 'GToolkitVariableBindings' with: [ spec 
				repository: 'github://feenkcom/gtoolkit-playground/src' ];
			baseline: 'GToolkitExamples' with: [ spec 
				repository: 'github://feenkcom/gtoolkit-examples/src' ];
			baseline: 'GToolkitInspector' with: [ spec
				repository: 'github://feenkcom/gtoolkit-inspector/src' ];
			baseline: 'Pillar' with: [ spec
				"repository: 'github://pillar-markup/pillar/src'"
				repository: 'github://pillar-markup/pillar:dev-7/src'
				"repository: 'github://feenkcom/pillar:dev-7/src'" ];
			baseline: 'PetitParser2Core' with: [
				spec
				 	repository: 'github://kursjan/petitparser2' ];
			project: 'DeepTraverser' with: [ spec
				className: #ConfigurationOfDeepTraverser;
				versionString: #development;
				repository: 'http://smalltalkhub.com/mc/Moose/DeepTraverser/main/' ];
			package: 'GToolkit-Documenter-BrTextPetitParserCompatibility' with: [ spec requires: #( 
				#Pillar #GToolkitUtility ) ];
			package: 'Pillar2-PetitPillar' with: [ spec requires: #( 
				#'PetitParser2Core' #'Pillar' ) ];
			package: 'Pillar2-Tests-PetitPillar' with: [ spec requires: #( 
				#'Pillar2-PetitPillar' ) ];
			package: 'GToolkit-Documenter' with: [ spec requires: #( 
				#Brick #Pillar #GToolkitCompleter
				#GToolkitUtility 
				#GToolkitVariableBindings
				#GToolkitExamples 
				#GToolkitInspector
				#'Pillar2-Tests-PetitPillar'
				#'GToolkit-Documenter-BrTextPetitParserCompatibility' ) ];
			package: 'GToolkit-Documenter-Exporter' with: [ spec requires: #( 
				#Brick #Pillar #GToolkitUtility 'GToolkit-Documenter' ) ];
			package: 'GToolkit-Documenter-Exporter-Tests' with: [ spec requires: #( 
				'GToolkit-Documenter-Exporter' ) ];
			package: 'GToolkit-Documenter-Epicea' with: [ spec requires: #(
				 'Brick' 'GToolkitUtility' 'GToolkit-Documenter' 'GToolkit-Documenter-Exporter' ) ];
			package: 'GToolkit-Documenter-Examples' with: [ spec requires: #( 
				'GToolkitExamples' 'GToolkit-Documenter' 'GToolkit-Documenter-Exporter'
				'GToolkit-Documenter-Epicea' ) ]
	].

	spec for: #'pharo6.x' do: [ 
		spec
			preLoadDoIt: #updateZincHTTPComponetns:;
			project: 'ZincHTTPComponentsCharacterEncoding' with: [ 
				spec
					className: #ConfigurationOfZincHTTPComponents;
					repository: 'http://smalltalkhub.com/mc/SvenVanCaekenberghe/ZincHTTPComponents/main/';
					versionString: #stable;
					loads: 'Character-Encoding' ];
			package: 'GToolkit-Documenter-Exporter' with: [ spec requires: #( 
				#ZincHTTPComponentsCharacterEncoding "
				#Brick #Pillar #GToolkitUtility 'GToolkit-Documenter'" ) ]
	].
]

{ #category : #private }
BaselineOfGToolkitDocumenter >> updateZincHTTPComponetns: spec [
	Gofer it
		smalltalkhubUser: 'SvenVanCaekenberghe' project: 'ZincHTTPComponents';
		package: 'ConfigurationOfZincHTTPComponents';
		load
]