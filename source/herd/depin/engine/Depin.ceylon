import ceylon.language.meta.declaration {
	FunctionOrValueDeclaration
}

import herd.depin.api {
	Dependency,
	Injection,
	Identification,
	Notifier,
	Injectable
}
import herd.depin.engine.dependency {
	DependencyFactory,
	DefinitionFactory,
	Dependencies,
	MasterDecorator,
	Handlers,
	MasterNotifier
}
import herd.depin.engine.injection {
	InjectionFactory
}



shared class Depin satisfies Injection.Injector& Notifier{
	shared static abstract class State() of ready{}
	shared static object ready extends State(){}

	InjectionFactory factory;
	Dependencies tree;
	Notifier masterNotifier;
	shared new({FunctionOrValueDeclaration*} dependencies={},Configuration configuration=Configuration()){
		tree=Dependencies();
		value handlers=Handlers();
		value definitionFactory=DefinitionFactory(Identification.Holder(configuration.identificationTypes));
		value targetSelector=TargetSelector();
		value dependencyFactory=DependencyFactory(definitionFactory,targetSelector,tree);
		value masterDecorator=MasterDecorator(handlers);
		masterNotifier=MasterNotifier(handlers);
		factory=InjectionFactory(dependencyFactory,targetSelector);
		
		dependencies.map((FunctionOrValueDeclaration element) => dependencyFactory.create(element,false))
				.map((Dependency element) => tree.add(element))
				.narrow<Dependency>()
				.group((Dependency element) => element.definition)
				.each((Dependency.Definition elementKey -> [Dependency+] elementItem) {
			throw Exception("Multiple dependencies found for single definition: ``elementKey``-> ``elementItem`` ");
		});
		tree.replace(masterDecorator.decorate);	
	}



	
	shared actual Type inject<Type>(Injectable<Type> model){
		assert(is Type result= factory.create(model).inject);
		return result;
	}
	shared actual void notify<Event>(Event event) {
		masterNotifier.notify(event);
	}
	
	
	
	
	
	
	
}
