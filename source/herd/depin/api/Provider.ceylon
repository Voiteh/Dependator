
import ceylon.language.meta.declaration {
	Declaration
}
shared interface Provider {
	
	shared formal Injectable provide(Declaration declaration,Dependency dependency);
	
	
}