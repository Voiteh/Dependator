import ceylon.language.meta.declaration {
	Declaration
}

import herd.depin.api {
	Dependency,
	Definition
}
shared class DependencyProvider(Definition.Factory factory,Dependency.Registry registry) satisfies Dependency.Provider{
	shared actual Anything provide(Declaration declaration) {
		value definition = factory.create(declaration);
		value dependency = registry.get(definition);
		return dependency?.provide(this) else null;
	}
	
}