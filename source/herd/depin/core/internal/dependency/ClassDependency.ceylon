import herd.depin.core {
	Dependency
}
import ceylon.language.meta.declaration {
	ClassDeclaration
}


shared class ClassDependency(
	String name,
	TypeIdentifier identification,
	ClassDeclaration declaration,
	Dependency constructorDependency
) extends Dependency(name,identification,declaration) satisfies Exposing{
	shared actual Anything resolve => constructorDependency.resolve;
	
	shared actual Dependency exposed = constructorDependency;
	
	
}
