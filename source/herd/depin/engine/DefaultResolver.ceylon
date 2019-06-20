import herd.depin.api {
	Resolver,
	Dependency,
	Registry
}
import ceylon.language.meta.declaration {
	Declaration
}

shared class DefaultResolver(Registry registry) satisfies Resolver{
	shared actual Dependency resolve(Declaration declaration) => nothing;
		
	
}