import ceylon.language.meta.declaration {
	Declaration
}
shared interface Provider {
	
	shared formal Anything provide(Declaration declaration);
	
	
}