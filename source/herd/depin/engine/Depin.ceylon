import ceylon.language.meta.declaration {
	FunctionOrValueDeclaration
}
import ceylon.language.meta.model {
	ClassModel,
	Type
}

import herd.depin.api {
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



shared class Depin {
	
	Identification.Holder holder;
	Definition.Factory definitionFactory;
	Dependency.Registry registry; 
	Dependency.Factory dependencyFactory;
	Dependency.Provider dependencyProvider;
	Target.Injector injector; 
	
	shared new({FunctionOrValueDeclaration*} dependencies={},Type<Annotation>[] identificationTypes=[`NamedAnnotation`] ){
		
		holder=Identification.Holder(identificationTypes);
		definitionFactory=DefinitionFactory(holder);
		registry =DependencyRegistry();
		dependencyFactory=DependencyFactory(definitionFactory);
		dependencyProvider=DependencyProvider(definitionFactory,registry);
		injector =TargetInjector(TargetFactory(), dependencyProvider);
		
		dependencies.flatMap((FunctionOrValueDeclaration element) => dependencyFactory.create(element))
				.distinct
				.map((Dependency element) => registry.add(element))
				.narrow<Dependency>()
				.group((Dependency element) => element.definition)
				.each((Definition elementKey -> [Dependency+] elementItem) {
			throw Exception("Multiple dependencies found for single definition: ``elementKey``-> ``elementItem`` ");
		});
	}

shared new custom(Identification.Holder holder,
	Definition.Factory definitionFactory,
	Dependency.Registry registry,
	Dependency.Factory dependencyFactory,
	Dependency.Provider dependencyProvider,
	Target.Injector injector )	{
	
	this.injector = injector;
	this.dependencyProvider = dependencyProvider;
	this.dependencyFactory = dependencyFactory;
	this.registry = registry;
	this.definitionFactory = definitionFactory;
	this.holder = holder;

	
}

	
	shared Type inject<Type>(ClassModel<Type> model)given Type satisfies Object {
		return injector.inject<Type>(model);
	
	}
	
	
	
	
	
	
}
