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
	TargetSelector,
	log
}


shared class DependencyFactory(DefinitionFactory definitionFactory,TargetSelector targetSelector,Dependencies tree)  {
	{Dependency.Decorator*} decorators(AnnotatedDeclaration declaration){
		return declaration.annotations<Annotation>()
				.narrow<Dependency.Decorator>();
	}
	
	shared Dependency create(NestableDeclaration declaration,Boolean parameter) {
		
		Dependency dependency;
		if(parameter){
			Dependency.Definition definition =  definitionFactory.create(declaration);
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
				Dependency.Definition definition =  definitionFactory.create(declaration);
				value parameterDependencies = declaration.parameterDeclarations
						.map((FunctionOrValueDeclaration element) => create(element,true));
				dependency= FunctionalDependency( definition, containerDependency, parameterDependencies,decorators(declaration));
				
			}
			else case (is ValueDeclaration) {
				Dependency.Definition definition =  definitionFactory.create(declaration);
				dependency= ValueDependency(definition, containerDependency,decorators(declaration));
	
			}
			else case (is ClassDeclaration) {
				if (exists anonymousObjectDeclaration = declaration.objectValue) {
					Dependency.Definition definition =  definitionFactory.create(anonymousObjectDeclaration);
					dependency= ValueDependency(definition,containerDependency,decorators(declaration)) ;
				} else { 
					value constructor = targetSelector.select(declaration);
					Dependency.Definition definition =  definitionFactory.create(constructor);
					switch(constructor) 
					case(is CallableConstructorDeclaration ){
						value parameterDependencies = constructor.parameterDeclarations
								.map((FunctionOrValueDeclaration element) => ParameterDependency(definitionFactory.create(element), tree));
						dependency= FunctionalDependency( definition, containerDependency, parameterDependencies,decorators(declaration));
					}
					case(is ValueConstructorDeclaration){
						dependency= ValueDependency(definition,containerDependency,decorators(declaration)) ;
					}
				}
			}
			else {
				throw FactorizationError(declaration, "Not supported");
			}
		}
		log.debug("[Created Dependency]: ``dependency``, for declaration: ``declaration``, parameter: ``parameter``");
		return dependency;
	}
	
	shared class FactorizationError(Declaration declaration,String message,Throwable? cause=null) 
			extends Exception("[``declaration``] ``message``",cause){}
}
