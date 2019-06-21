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
	Dependency,
	Creator
}

shared class Depin(
	Scanner scanner=DefaultScanner(),
	Registry registry =DefaultRegistry(),
	Provider provider =DefaultProvider(registry),
	Resolver resolver =DefaultResolver(registry),
	Creator creator=DefaultCreator(registry, resolver)
) {

	shared Depin include({Scope*} inclusions,{Scope*} exclusions={}){
		{Declaration*} declarations = scanner.scan(inclusions, exclusions);
		declarations.map((Declaration element) => [element,resolver.resolve(element)])
		.map(([Declaration, Dependency] element) => [element.rest.first,provider.provide(*element)])
		.map(([Dependency, Injectable] element) => [element.first,registry.add(*element)])
		.narrow<[Dependency, Injectable]>()
		.group(([Dependency, Injectable] element) => element.first)
		.map((Dependency elementKey -> [[Dependency, Injectable]+] elementItem) =>
			elementKey->elementItem.map(([Dependency, Injectable] element) => element.rest.first))
		.each((Dependency elementKey -> {Injectable+} elementItem) { 
			throw Exception("Multiple dependencies found for single definition: ``elementKey``-> ``elementItem`` ");});
		return this;
	}
	shared Type inject<Type>(Class<Type> model) {
		Dependency dependency = resolver.resolve(model.declaration);
		Injectable injection = provider.provide(model.declaration, dependency);
		assert(is Type result =injection.inject(creator));
		return result;
	}
	
	
	
	
	
	
}
