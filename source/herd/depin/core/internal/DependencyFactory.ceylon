import ceylon.language.meta.declaration {
	ValueDeclaration,
	NestableDeclaration,
	CallableConstructorDeclaration,
	ValueConstructorDeclaration,
	ClassDeclaration,
	FunctionalDeclaration,
	Declaration,
	FunctionOrValueDeclaration,
	OpenClassType
}

import herd.depin.core {
	log,
	Collector,
	Dependency
}



shared class DependencyFactory(DefinitionFactory definitionFactory,TargetSelector targetSelector,Dependencies tree)  {
	
	
	shared Dependency create(NestableDeclaration declaration,Boolean reaching) {
		
		Dependency dependency;
		if(reaching){
			Dependency.Definition definition =  definitionFactory.create(declaration);
			assert(is FunctionOrValueDeclaration declaration);
			if(is OpenClassType declarationOpenType=declaration.openType,declarationOpenType.declaration==`class Collector`){
				dependency=CollectorDependency(definition, tree);					
			}
			else if(declaration.defaulted){
				dependency= DefaultedReachingDependency(definition, tree);
			}else{
				dependency=ReachingDependency(definition, tree);
			}
		}
		else{
			Dependency? containerDependency ;
			if(declaration.formal){
				throw Exception("Formal declarations not allowed: ``declaration```");
			}
			if (is NestableDeclaration containerDeclaration = declaration.container) {
				 containerDependency=create(containerDeclaration,false);
			}else{
				containerDependency=null;
			}
			switch (declaration)
			case (is FunctionalDeclaration) {
				Dependency.Definition definition =  definitionFactory.create(declaration);
				value parameterDependencies = declaration.parameterDeclarations
 						.collect((FunctionOrValueDeclaration element) => create(element,true));
				dependency= FunctionalDependency( definition, containerDependency, parameterDependencies);
				
			}
			else case (is ValueDeclaration) {
				Dependency.Definition definition =  definitionFactory.create(declaration);
				dependency= ValueDependency(definition, containerDependency);
	
			}
			else case (is ClassDeclaration) {
				if (exists anonymousObjectDeclaration = declaration.objectValue) {
					Dependency.Definition definition =  definitionFactory.create(anonymousObjectDeclaration);
					dependency= ValueDependency(definition,containerDependency) ;
				} else { 
					value constructor = targetSelector.select(declaration);
					Dependency.Definition definition =  definitionFactory.create(constructor);
					switch(constructor) 
					case(is CallableConstructorDeclaration ){
						value parameterDependencies = constructor.parameterDeclarations
								.collect((FunctionOrValueDeclaration element) => ReachingDependency(definitionFactory.create(element), tree));
						dependency= FunctionalDependency( definition, containerDependency, parameterDependencies);
					}
					case(is ValueConstructorDeclaration){
						dependency= ValueDependency(definition,containerDependency) ;
					}
				}
			}
			else {
				throw FactorizationError(declaration, "Not supported");
			}
		}
		log.debug("[Created Dependency]: ``dependency``, for declaration: ``declaration``, parameter: ``reaching``");
		return dependency;
	}
	
	shared class FactorizationError(Declaration declaration,String message,Throwable? cause=null) 
			extends Exception("[``declaration``] ``message``",cause){}
}
