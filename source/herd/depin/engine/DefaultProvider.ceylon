import herd.depin.api {
	Provider,
	Injectable,
	Dependency,
	Registry
}
import ceylon.language.meta.model {
	Type
}
import ceylon.language.meta.declaration {
	Declaration
}
shared class DefaultProvider(Registry registry) satisfies Provider{
	shared actual Injectable provide(Declaration declaration, Dependency dependency) => nothing;
	

	
}