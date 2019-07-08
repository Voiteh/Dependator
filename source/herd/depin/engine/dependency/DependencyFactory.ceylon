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


shared class DependencyFactory(DefinitionFactory definitionFactory,TargetSelector targetSelector,Dependencies tree)  {
	
	{Dependency.Decorator*} decorators(AnnotatedDeclaration declaration){
		return declaration.annotations<Annotation>()
				.narrow<Dependency.Decorator>();
	}
	
	shared Dependency create(NestableDeclaration declaration,Boolean parameter) {
		Dependency.Definition definition =  definitionFactory.create(declaration);
		if(parameter){
			assert(is FunctionOrValueDeclaration declaration);
			if(declaration.defaulted){
				return DefaultedParameterDependency(definition, tree);
			}
			return ParameterDependency(definition, tree);
		}
		
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
			return FunctionalDependency(declaration, definition, containerDependency, parameterDependencies,decorators(declaration));
			
		}
		else case (is ValueDeclaration) {
			return ValueDependency(declaration, definition, containerDependency,decorators(declaration));

		}
		else case (is ClassDeclaration) {
			if (exists anonymousObject = declaration.objectValue) {
				return ValueDependency(anonymousObject,definition,containerDependency,decorators(declaration)) ;
			} else {
				switch(constructor=targetSelector.select(declaration)) 
				case(is CallableConstructorDeclaration ){
					value parameterDependencies = constructor.parameterDeclarations
							.map((FunctionOrValueDeclaration element) => ParameterDependency(definitionFactory.create(element), tree));
					return FunctionalDependency(constructor, definition, containerDependency, parameterDependencies,decorators(declaration));

				}
				case(is ValueConstructorDeclaration){
					return ValueDependency(constructor,definition,containerDependency,decorators(declaration)) ;
				}
			}
			
		}
		else {
			throw FactorizationError(declaration, "Not supported");
		}
	}
	
	shared class FactorizationError(Declaration declaration,String message,Throwable? cause=null) 
			extends Exception("[``declaration``] ``message``",cause){}
}
