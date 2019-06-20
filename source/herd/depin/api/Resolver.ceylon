import ceylon.language.meta.declaration {
	Declaration
}


shared interface Resolver {
	
	shared formal Dependency resolve(Declaration declaration);
	
}