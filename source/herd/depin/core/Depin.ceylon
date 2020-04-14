import ceylon.language.meta.declaration {
	FunctionOrValueDeclaration,
	ClassDeclaration,
	Declaration
}

import herd.depin.core.internal {
	InjectionFactory,
	TargetSelector,
	DecorationManager,
	TypesFactory,
	Handlers,
	NotificationManager,
	DependencyFactory
}
import herd.depin.core.internal.dependency {
	Tree,
	Exposing,
	TypeIdentifier
}

shared class FactorizationError(Declaration declaration,String message,Throwable? cause=null) 
		extends Exception("[``declaration``] ``message``",cause){}

"Main entry point for this framework to operate. "
throws(`class FactorizationError`,"Can't create given dependency from provided declaration")
shared class Depin {
	"Notification state used by [[Handler]]s to allocate resources whenver [[Depin]] finishes initialization"
	shared static abstract class State() of ready{}
	"[[Depin]] is ready"
	shared static object ready extends State(){}

	InjectionFactory factory;
	Tree tree;
	TypesFactory typesFactory;
	DependencyFactory dependencyFactory;
	NotificationManager notificationManager;
	
	void validate({Dependency*} dependencies){
		dependencies.group((Dependency element) => element.name->element.identifier)
				.filter((String->TypeIdentifier elementKey -> [Dependency+] elementItem) => !elementItem.rest.empty)
				.each((String->TypeIdentifier elementKey -> [Dependency+] elementItem) {
			throw Exception("Multiple dependencies found for single name: ``elementKey``-> ``elementItem`` ");
		});
	}
	
	"Transforms given declarations into dependencies allowing for further injection."
	shared new(
		"Declarations transformed into [[Tree]]"
		{ClassDeclaration|FunctionOrValueDeclaration*} declarations={}
	){
		tree=Tree();
		value handlers=Handlers();
		typesFactory=TypesFactory();
		
		value targetSelector=TargetSelector();
		dependencyFactory=DependencyFactory(typesFactory,targetSelector,tree);
		value decorationManager=DecorationManager(handlers);
		notificationManager=NotificationManager(handlers);
		factory=InjectionFactory(dependencyFactory,targetSelector);
		
		value dependencies = declarations.collect((ClassDeclaration|FunctionOrValueDeclaration element) => dependencyFactory.create(element));
		validate(dependencies);	
		dependencies.map(decorationManager.decorate)
		.each((Dependency|Dependency.Decoration element)  {
			tree.add(element);
			if(is Dependency.Decoration element, element.decorators.narrow<FallbackDecorator>().first exists){
				tree.addFallback(element);
			}
			if(is Exposing element ){
				tree.add(element.exposed);
			}
		});
		notificationManager.notify(ready);
	}
	"Support entry point, for retreiving results of dependency resolution. 
	 Usable in frameworks like Android SDK or libgdx, where there is no possiblity to nicely create,
	  new instance of given model but [[late]] attributes, needs to be provided manually in onCreate, see examples"
	throws(`class Dependency.ResolutionError`, "Dependency can't be find for given declaration")
	shared Result extract<Result>(FunctionOrValueDeclaration declaration){
		value dependency=dependencyFactory.createParameter(declaration);
		assert(is Result result= dependency.resolve);
		return result;
	}


	"Main functionality of this framework allowing to instantaite or call given [[Injectable]] using it's model. 
	 Be aware that for [[ceylon.language.meta.model:ValueModel]], [[inject]] always create new instance of given model. 
	 For [[ceylon.language.meta.model:FunctionModel]] result depends on implementation of function."
	throws(`class Injection.Error`,"One of dependencies fails to resolve")
	shared  Result inject<Result>(Injectable<Result> model){
		assert(is Result result= factory.create(model).inject);
		log.debug("[Injection] of ``model `` succesfull, with result: ``result else "null"``");
		return result;
	}
	"Allows notification of [[Dependency.Decorator]] [[Handler]]s, with given [[event]]. This method honors type hierarchies so subtype events, will notify supertype [[Handler]]s,
	 this also includes interfaces." 
	shared  void notify<Event>(Event event) {
		notificationManager.notify(event);
	}
	
	
	
	
	
	
	
}
