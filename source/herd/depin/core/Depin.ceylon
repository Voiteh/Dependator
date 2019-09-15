import ceylon.language.meta.declaration {
	FunctionOrValueDeclaration
}

import herd.depin.core.internal {
	InjectionFactory,
	TargetSelector,
	DecorationManager,
	DefinitionFactory,
	Dependencies,
	DependencyFactory,
	Handlers,
	NotificationManager
}



"Main entry point for this framework to operate. "
shared class Depin {
	"Notification state used by [[Handler]]s to allocate resources whenver [[Depin]] finishes initialization"
	shared static abstract class State() of ready{}
	"[[Depin]] is ready"
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
	
	"Transforms given declarations into dependencies allowing for further injection."
	shared new(
		"Declarations transformed into [[Dependencies]]"
		{FunctionOrValueDeclaration*} declarations={}
	){
		tree=Dependencies();
		value handlers=Handlers();
		value definitionFactory=DefinitionFactory(Identification.Holder([`NamedAnnotation`]));
		value targetSelector=TargetSelector();
		value dependencyFactory=DependencyFactory(definitionFactory,targetSelector,tree);
		value decorationManager=DecorationManager(handlers);
		notificationManager=NotificationManager(handlers);
		factory=InjectionFactory(dependencyFactory,targetSelector);
		
		value dependencies = declarations.collect((FunctionOrValueDeclaration element) => dependencyFactory.create(element,false));
		validate(dependencies);	
		dependencies.map(decorationManager.decorate)
		.each((Dependency|Dependency.Decorated element)  {
			tree.add(element);
			if(is Dependency.Decorated element, element.decorators.narrow<FallbackDecorator>().first exists){
				tree.addFallback(element);
			}
		});
		notificationManager.notify(ready);
	}


	"Main functionality of this framework allowing to instantaite or call given [[Injectable]] using it's model"
	throws(`class Injection.Error`,"One of dependencies fails to resolve")
	shared  Type inject<Type>(Injectable<Type> model){
		assert(is Type result= factory.create(model).inject);
		log.debug("Injection into ``model `` succesfull, with result: ``result else "null"``");
		return result;
	}
	"Allows notification of [[Dependency.Decorator]] [[Handler]]s, with given [[event]]. This method honors type hierarchies so subtype events, will notify supertype [[Handler]]s,
	 this also includes interfaces." 
	shared  void notify<Event>(Event event) {
		notificationManager.notify(event);
	}
	
	
	
	
	
	
	
}
