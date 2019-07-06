import ceylon.language.meta.declaration {
	FunctionOrValueDeclaration
}
import ceylon.language.meta.model {
	ClassModel,
	Type
}

import herd.depin.api {
	Dependency,
	Injection,
	Identification,
	NamedAnnotation
}
import herd.depin.engine.dependency {
	DependencyFactory,
	DefinitionFactory,
	DependencyTree
}
import herd.depin.engine.injection {
	InjectionFactory
}



shared class Depin satisfies Injection.Injector{
	

	InjectionFactory factory;
	Dependency.Tree tree;
	
	shared new({FunctionOrValueDeclaration*} dependencies={},Type<Annotation>[] identificationTypes=[`NamedAnnotation`] ){
		tree=DependencyTree();
		value mutator=tree.Mutator();
		value definitionFactory=DefinitionFactory(Identification.Holder(identificationTypes));
		value targetSelector=TargetSelector();
		value dependencyFactory=DependencyFactory(definitionFactory,targetSelector,tree);
		factory=InjectionFactory(dependencyFactory,targetSelector);
		
		dependencies.map((FunctionOrValueDeclaration element) => dependencyFactory.create(element,false))
				.map((Dependency element) => mutator.add(element))
				.narrow<Dependency>()
				.group((Dependency element) => element.definition)
				.each((Dependency.Definition elementKey -> [Dependency+] elementItem) {
			throw Exception("Multiple dependencies found for single definition: ``elementKey``-> ``elementItem`` ");
		});
	}



	
	shared actual Type inject<Type>(ClassModel<Type> model)given Type satisfies Object {
		assert(is Type result= factory.create(model).inject);
		return result;
	}
	
	
	
	
	
	
}
