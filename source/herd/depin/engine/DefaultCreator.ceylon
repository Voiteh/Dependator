import herd.depin.api {
	Registry,
	Creator,
	Resolver
}
import ceylon.language.meta.declaration {
	Declaration
}

shared class DefaultCreator(Registry registry,Resolver resolver) satisfies Creator{
	
	
	shared actual Anything create(Declaration declaration) {
		value dependency = resolver.resolve(declaration);
		return registry.get(dependency)?.inject(this);
	}
	

	
}