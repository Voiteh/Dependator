import ceylon.language.meta.declaration {
	FunctionOrValueDeclaration,
	NestableDeclaration,
	ValueDeclaration
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
import ceylon.language.meta {

	type
}
import herd.depin.core.internal.util {

	doCompleate=compleate
}
import ceylon.language.meta.model {

	Value
}



"Main entry point for this framework to operate. "
shared class Depin {
	"Notification state used by [[Handler]]s to allocate resources whenver [[Depin]] finishes initialization"
	shared static abstract class State() of ready{}
	"[[Depin]] is ready"
	shared static object ready extends State(){}

	InjectionFactory factory;
	Dependencies tree;
	DefinitionFactory definitionFactory;
	DependencyFactory dependencyFactory;
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
		definitionFactory=DefinitionFactory(Identification.Holder([`NamedAnnotation`]));
		
		value targetSelector=TargetSelector();
		dependencyFactory=DependencyFactory(definitionFactory,targetSelector,tree);
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
	"Support entry point, for retreiving results of dependency resolution. 
	 Usable in frameworks like Android SDK or libgdx, where there is no possiblity to nicely create,
	  new instance of given model but [[late]] attributes, needs to be provided manually in onCreate"
	throws(`class Dependency.ResolutionError`, "Dependency can't be find for given declaration")
	shared Result extract<Result>(NestableDeclaration declaration){
		value dependency=dependencyFactory.create(declaration, true);
		assert(is Result result= dependency.resolve);
		return result;
	}
	throws(`class Dependency.ResolutionError`, "Dependency can't be find for given compleatable declaration")
	throws(`class CompleationException`, "Given target can't be compleated with provided dependencies ")
	shared void compleate(Object target){
		scanner.compleatables(target)
				.map((Value<> element) => [element,dependencyFactory.create(element.declaration, true).resolve])
			.each(([Value<>, Anything] element) => doCompleate(*element));
			
			
	}


	"Main functionality of this framework allowing to instantaite or call given [[Injectable]] using it's model. 
	 Be aware that for [[ceylon.language.meta.model:ValueModel]], [[inject]] always create new instance of given model. 
	 For [[ceylon.language.meta.model:FunctionModel]] result depends on implementation of function."
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
