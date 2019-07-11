import ceylon.language.meta.declaration {
	ValueDeclaration,
	NestableDeclaration,
	CallableConstructorDeclaration,
	ValueConstructorDeclaration,
	ClassDeclaration,
	FunctionalDeclaration,
	Declaration,
	FunctionOrValueDeclaration,
	AnnotatedDeclaration
}

import herd.depin.api {
	Dependency
}
import herd.depin.engine {
	TargetSelector
}
import ceylon.logging {

	createLogger=logger,
	Logger
}


shared class DependencyFactory(DefinitionFactory definitionFactory,TargetSelector targetSelector,Dependencies tree)  {
	{Dependency.Decorator*} decorators(AnnotatedDeclaration declaration){
		return declaration.annotations<Annotation>()
				.narrow<Dependency.Decorator>();
	}
	
	shared Dependency create(NestableDeclaration declaration,Boolean parameter) {
		Dependency.Definition definition =  definitionFactory.create(declaration);
		Dependency dependency;
		if(parameter){
			assert(is FunctionOrValueDeclaration declaration);
			if(declaration.defaulted){
				dependency= DefaultedParameterDependency(definition, tree);
			}else{
				dependency=ParameterDependency(definition, tree);
			}
		}
		else{
			Dependency? containerDependency ;
			if (is NestableDeclaration containerDeclaration = declaration.container) {
				 containerDependency=create(containerDeclaration,false);
			}else{
				containerDependency=null;
			}
			
			switch (declaration)
			case (is FunctionalDeclaration) {
				value parameterDependencies = declaration.parameterDeclarations
						.map((FunctionOrValueDeclaration element) => create(element,true));
				dependency= FunctionalDependency(declaration, definition, containerDependency, parameterDependencies,decorators(declaration));
				
			}
			else case (is ValueDeclaration) {
				dependency= ValueDependency(declaration, definition, containerDependency,decorators(declaration));
	
			}
			else case (is ClassDeclaration) {
				if (exists anonymousObject = declaration.objectValue) {
					dependency= ValueDependency(anonymousObject,definition,containerDependency,decorators(declaration)) ;
				} else {
					switch(constructor=targetSelector.select(declaration)) 
					case(is CallableConstructorDeclaration ){
						value parameterDependencies = constructor.parameterDeclarations
								.map((FunctionOrValueDeclaration element) => ParameterDependency(definitionFactory.create(element), tree));
						dependency= FunctionalDependency(constructor, definition, containerDependency, parameterDependencies,decorators(declaration));
	
					}
					case(is ValueConstructorDeclaration){
						dependency= ValueDependency(constructor,definition,containerDependency,decorators(declaration)) ;
					}
				}
				
			}
			else {
				throw FactorizationError(declaration, "Not supported");
			}
		}
		log.debug("Created dependency: ``dependency``, for declaration: ``declaration``, parameter``parameter``");
		return dependency;
	}
	
	shared class FactorizationError(Declaration declaration,String message,Throwable? cause=null) 
			extends Exception("[``declaration``] ``message``",cause){}
}
