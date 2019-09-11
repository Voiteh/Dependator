import ceylon.language.meta.declaration {
	FunctionOrValueDeclaration
}

import herd.depin.engine.internal {
	InjectionFactory,
	TargetSelector,
	DecorationManager,
	DefinitionFactory,
	Dependencies,
	DependencyFactory,
	Handlers,
	NotificationManager
}




shared class Depin {
	shared static abstract class State() of ready{}
	shared static object ready extends State(){}

	InjectionFactory factory;
	Dependencies tree;
	NotificationManager notificationManager;
	void validate({Dependency*} dependencies){
		dependencies.group((Dependency element) => element.definition)
				.filter((Dependency.Definition elementKey -> [Dependency+] elementItem) => !elementItem.rest.empty)
				.each((Dependency.Definition elementKey -> [Dependency+] elementItem) {
			throw Exception("Multiple dependencies found for single definition: ``elementKey``-> ``elementItem`` ");
		});
	}
	
	
	shared new({FunctionOrValueDeclaration*} declarations={}){
		tree=Dependencies();
		value handlers=Handlers();
		value definitionFactory=DefinitionFactory(Identification.Holder([`NamedAnnotation`]));
		value targetSelector=TargetSelector();
		value dependencyFactory=DependencyFactory(definitionFactory,targetSelector,tree);
		value decorationManager=DecorationManager(handlers);
		notificationManager=NotificationManager(handlers);
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



	throws(`class Injection.Error`,"One of dependencies fails to resolve")
	shared  Type inject<Type>(Injectable<Type> model){
		assert(is Type result= factory.create(model).inject);
		log.debug("Injection into ``model `` succesfull, with result: ``result else "null"``");
		return result;
	}
	shared  void notify<Event>(Event event) {
		notificationManager.notify(event);
	}
	
	
	
	
	
	
	
}
