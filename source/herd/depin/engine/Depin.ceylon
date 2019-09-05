import ceylon.language.meta.declaration {
	FunctionOrValueDeclaration
}

import herd.depin.api {
	Injection,
	Notifier,
	Injectable,
	FallbackAnnotation
}
import herd.depin.engine.dependency {
	DependencyFactory,
	DefinitionFactory,
	Dependencies,
	DecorationManager,
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
	
	void validate({Dependency*} dependencies){
		dependencies.group((Dependency element) => element.definition)
				.filter((Dependency.Definition elementKey -> [Dependency+] elementItem) => !elementItem.rest.empty)
				.each((Dependency.Definition elementKey -> [Dependency+] elementItem) {
			throw Exception("Multiple dependencies found for single definition: ``elementKey``-> ``elementItem`` ");
		});
	}
	
	
	shared new({FunctionOrValueDeclaration*} declarations={},Configuration configuration=Configuration()){
		tree=Dependencies();
		value handlers=Handlers();
		value definitionFactory=DefinitionFactory(Identification.Holder(configuration.identificationTypes));
		value targetSelector=TargetSelector();
		value dependencyFactory=DependencyFactory(definitionFactory,targetSelector,tree);
		value decorationManager=DecorationManager(handlers);
		masterNotifier=MasterNotifier(handlers);
		factory=InjectionFactory(dependencyFactory,targetSelector);
		
		value dependencies = declarations.map((FunctionOrValueDeclaration element) => dependencyFactory.create(element,false));
		validate(dependencies);	
		dependencies.map(decorationManager.decorate)
		.each((Dependency|Dependency.Decorated element)  {
			tree.add(element);
			if(is Dependency.Decorated element, element.decorators.narrow<FallbackAnnotation>().first exists){
				tree.addFallback(element);
			}
		});
		
	}



	
	shared actual Type inject<Type>(Injectable<Type> model){
		assert(is Type result= factory.create(model).inject);
		log.debug("Injection into ``model `` succesfull, with result: ``result else "null"``");
		return result;
	}
	shared actual void notify<Event>(Event event) {
		masterNotifier.notify(event);
	}
	
	
	
	
	
	
	
}
