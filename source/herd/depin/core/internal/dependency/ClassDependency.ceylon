import herd.depin.core {
	Dependency
}
import ceylon.language.meta.declaration {
	ClassDeclaration
}


shared class ClassDependency(
	ClassDeclaration declaration,
	TypeIdentifier identification,
	Dependency constructorDependency
) extends Dependency(declaration,identification) satisfies Exposing{
	shared actual Anything resolve => constructorDependency.resolve;
	
	shared actual Dependency exposed = constructorDependency;
	
	
}
