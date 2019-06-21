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
		if(exists injectable = registry.get(dependency)){
			return injectable.inject(this);
		}
		throw Exception("Dependency [``dependency``] not found in registry did You made a scan ? Available dependencies:\n +``registry``");
	}
	
	
	
	
}