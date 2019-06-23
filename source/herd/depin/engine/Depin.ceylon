import ceylon.language.meta.declaration {
	Declaration
}
import ceylon.language.meta.model {
	ClassModel
}

import herd.depin.api {
	Scanner,
	Scope,
	Dependency,
	Definition,
	Target,
	Identification,
	NamedAnnotation
}
import herd.depin.engine.dependency {
	DependencyProvider,
	DependencyFactory
}
import herd.depin.engine.target {
	TargetFactory
}



shared class Depin(
	Scanner scanner=DefaultScanner(),
	Identification.Holder holder=Identification.Holder([`NamedAnnotation`]),
	Definition.Factory definitionFactory=DefinitionFactory(holder),
	Dependency.Registry registry =DependencyRegistry(),
	Dependency.Factory dependencyFactory=DependencyFactory(definitionFactory),
	Dependency.Provider dependencyProvider=DependencyProvider(definitionFactory,registry),
	Target.Injector injector =TargetInjector(TargetFactory(), dependencyProvider)
) {

	shared Depin include({Scope*} inclusions,{Scope*} exclusions={}){
		scanner.scan(inclusions, exclusions)
		.map((Declaration element) => dependencyFactory.create(element))
		.map((Dependency element) => registry.add(element))
		.narrow<Dependency>()
		.group((Dependency element) => element.definition)
		.each((Definition elementKey -> [Dependency+] elementItem) {
			throw Exception("Multiple dependencies found for single definition: ``elementKey``-> ``elementItem`` ");
		});
		return this;
	}
	shared Type inject<Type>(ClassModel<Type> model)given Type satisfies Object {
		return injector.inject<Type>(model);
	
	}
	
	
	
	
	
	
}
