import ceylon.language.meta.declaration {
	Declaration
}
import ceylon.language.meta.model {
	Class
}

import herd.depin.api {
	Scanner,
	Scope,
	Registry,
	Injectable,
	Provider,
	Resolver,
	Dependency
}

shared class Depin(
	Scanner scanner=DefaultScanner(),
	Registry registry =DefaultRegistry(),
	Provider provider =DefaultProvider(registry),
	Resolver resolver =DefaultResolver(registry)

) {

	shared Depin include({Scope*} inclusions,{Scope*} exclusions){
		value declarations = scanner.scan(inclusions, exclusions);
		declarations.map((Declaration element) => [element,resolver.resolve(element)])
		.map(([Declaration, Dependency] element) => [element.rest.first,provider.provide(*element)])
		.each(([Dependency, Injectable] element) => registry.add(*element));
		return this;
	}
	shared Object inject(Class<Object> model) {
		value dependency = resolver.resolve(model.declaration);
		value injection = provider.provide(model.declaration, dependency);
		assert(is Object result =injection.inject(provider, resolver));
		return result;
	}
	
	
	
	
	
	
}
