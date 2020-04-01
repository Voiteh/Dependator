import ceylon.language.meta.declaration {
	ValueDeclaration,
	NestableDeclaration,
	CallableConstructorDeclaration,
	ValueConstructorDeclaration,
	ClassDeclaration,
	FunctionalDeclaration,
	FunctionOrValueDeclaration,
	OpenClassType
}

import herd.depin.core {
	log,
	Collector,
	Dependency,
	FactorizationError
}



shared class DependencyFactory(DefinitionFactory definitionFactory,TargetSelector targetSelector,Dependencies tree)  {
	
	
	shared Dependency create(NestableDeclaration declaration,Boolean parameter) {
		
		Dependency dependency;
		if(parameter){
			Dependency.Definition definition =  definitionFactory.create(declaration);
			assert(is FunctionOrValueDeclaration declaration);
			if(is OpenClassType declarationOpenType=declaration.openType,declarationOpenType.declaration==`class Collector`){
				dependency=CollectorDependency(declaration,definition, tree);					
			}
			else if(declaration.defaulted){
				dependency= DefaultedParameterDependency(declaration,definition, tree);
			}else{
				dependency=ParameterDependency(declaration,definition, tree);
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
				dependency= FunctionalDependency(declaration, definition, containerDependency, parameterDependencies);
				
			}
			else case (is ValueDeclaration) {
				Dependency.Definition definition =  definitionFactory.create(declaration);
				dependency= GettableDependency(declaration,definition, containerDependency);
	
			}
			else case (is ClassDeclaration) {
				if(declaration.abstract){
					throw FactorizationError(declaration,"Can't create dependency out of abstract class");
				}
				else if (exists anonymousObjectDeclaration = declaration.objectValue) {
					Dependency.Definition definition =  definitionFactory.create(anonymousObjectDeclaration);
					dependency= GettableDependency(anonymousObjectDeclaration,definition,containerDependency) ;
				} else { 
					
					value constructor = targetSelector.select(declaration);
					Dependency.Definition constructorDefinition =  definitionFactory.create(constructor);
					Dependency constructorDependency;
					switch(constructor) 
					case(is CallableConstructorDeclaration ){
						value parameterDependencies = constructor.parameterDeclarations
								.collect((FunctionOrValueDeclaration element) => ParameterDependency(constructor,definitionFactory.create(element), tree));
						constructorDependency= FunctionalDependency(constructor, constructorDefinition, containerDependency, parameterDependencies);
					}
					case(is ValueConstructorDeclaration){
						constructorDependency= GettableDependency(constructor,constructorDefinition,containerDependency) ;
					}
					value classDefinitnion=definitionFactory.create(declaration);
					dependency=ClassDependency(declaration, classDefinitnion, constructorDependency);
				}
			}
			else {
				throw FactorizationError(declaration, "Not supported");
			}
		}
		log.debug("[Created Dependency]: ``dependency``, for declaration: ``declaration``, parameter: ``parameter``");
		return dependency;
	}
	
	
}
