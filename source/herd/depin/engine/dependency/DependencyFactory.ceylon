import ceylon.language.meta.declaration {
	ValueDeclaration,
	NestableDeclaration,
	CallableConstructorDeclaration,
	ValueConstructorDeclaration,
	ClassDeclaration,
	FunctionalDeclaration,
	Declaration,
	FunctionOrValueDeclaration
}

import herd.depin.api {
	Dependency
}
import herd.depin.engine {
	TargetSelector
}


shared class DependencyFactory(DefinitionFactory definitionFactory,TargetSelector targetSelector,Dependency.Tree tree)  {
	
	
	shared Dependency create(NestableDeclaration declaration,Boolean parameter) {
		Dependency.Definition definition =  definitionFactory.create(declaration);
		if(parameter){
			assert(is FunctionOrValueDeclaration declaration);
			if(declaration.defaulted){
				return DefaultedParameterDependency(definition, tree);
			}
			return ParameterDependency(definition, tree);
		}
		variable {Dependency*} parameterDependencies;
		Dependency? containerDependency ;
		if (is NestableDeclaration containerDeclaration = declaration.container) {
			 containerDependency=create(containerDeclaration,false);
		}else{
			containerDependency=null;
		}

		switch (declaration)
		case (is FunctionalDeclaration) {
			parameterDependencies = declaration.parameterDeclarations
					.map((FunctionOrValueDeclaration element) => create(element,true));
			return FunctionalDependency(declaration, definition, containerDependency, parameterDependencies);
			
		}
		else case (is ValueDeclaration) {
			return ValueDependency(declaration, definition, containerDependency);

		}
		else case (is ClassDeclaration) {
			if (exists anonymousObject = declaration.objectValue) {
				return ValueDependency(anonymousObject,definition,containerDependency) ;
			} else {
				switch(constructor=targetSelector.select(declaration)) 
				case(is CallableConstructorDeclaration ){
					parameterDependencies = constructor.parameterDeclarations
							.map((FunctionOrValueDeclaration element) => ParameterDependency(definitionFactory.create(element), tree));
					return FunctionalDependency(constructor, definition, containerDependency, parameterDependencies);

				}
				case(is ValueConstructorDeclaration){
					return ValueDependency(constructor,definition,containerDependency) ;
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
