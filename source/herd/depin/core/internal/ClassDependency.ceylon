import herd.depin.core {
	Dependency
}
import ceylon.language.meta.declaration {
	ClassDeclaration
}

shared class ClassDependency(
	ClassDeclaration declaration,
	Dependency.Definition definition,
	Dependency constructorDependency
) extends Dependency(declaration,definition) satisfies Exposing{
	shared actual Anything resolve => constructorDependency.resolve;
	
	shared actual Dependency exposed = constructorDependency;
	
	
}
