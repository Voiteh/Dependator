import ceylon.language.meta.declaration {
	ValueDeclaration,
	NestableDeclaration,
	CallableConstructorDeclaration,
	ValueConstructorDeclaration,
	ClassDeclaration,
	FunctionalDeclaration,
	FunctionOrValueDeclaration,
	OpenClassType,
	OpenType
}

import herd.depin.core {
	log,
	Collector,
	Dependency,
	FactorizationError
}

import herd.depin.core.internal.dependency {
	FunctionalOpenType,
	CollectorDependency,
	FunctionalDependency,
	ParameterDependency,
	DefaultedParameterDependency,
	Tree,
	GettableDependency,
	ClassDependency,
	TypeIdentifier
}



shared class DependencyFactory(TypesFactory identificationFactory,TargetSelector targetSelector,Tree tree)  {
	
	
	shared Dependency create(NestableDeclaration declaration,Boolean parameter) {
		
		Dependency dependency;
		if(parameter){
			TypeIdentifier types =  identificationFactory.forDeclaration(declaration);
			assert(is FunctionOrValueDeclaration declaration);
			if(is OpenClassType collectorType=declaration.openType,collectorType.declaration==`class Collector`){
				assert(exists collectedType=collectorType.typeArgumentList.first);
				value collectedTypes = identificationFactory.forType(collectedType);
				dependency=CollectorDependency(declaration,types,collectedTypes, tree);					
			}
			else if(declaration.defaulted){
				dependency= DefaultedParameterDependency(declaration,types, tree);
			}else{
				dependency=ParameterDependency(declaration,types, tree);
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
				FunctionalOpenType identification =  identificationFactory.forFunctionalDeclaration(declaration);
				value parameterDependencies = declaration.parameterDeclarations
 						.collect((FunctionOrValueDeclaration element) => create(element,true));
				dependency= FunctionalDependency(declaration, identification, containerDependency, parameterDependencies);
				
			}
			else case (is ValueDeclaration) {
				OpenType identification =  identificationFactory.forGettableDeclaration(declaration);
				dependency= GettableDependency(declaration,identification, containerDependency);
	
			}
			else case (is ClassDeclaration) {
				if(declaration.abstract){
					throw FactorizationError(declaration,"Can't create dependency out of abstract class");
				}
				else if (exists anonymousObjectDeclaration = declaration.objectValue) {
					OpenType definition =  identificationFactory.forGettableDeclaration(anonymousObjectDeclaration);
					dependency= GettableDependency(anonymousObjectDeclaration,definition,containerDependency) ;
				} else { 
					value constructor = targetSelector.select(declaration);
					
					Dependency constructorDependency;
					switch(constructor) 
					case(is CallableConstructorDeclaration ){
						FunctionalOpenType constructorTypes =  identificationFactory.forFunctionalDeclaration(constructor);
						value parameterDependencies = constructor.parameterDeclarations
								.collect((FunctionOrValueDeclaration element) => ParameterDependency(constructor,identificationFactory.forDeclaration(element), tree));
						constructorDependency= FunctionalDependency(constructor, constructorTypes, containerDependency, parameterDependencies);
					}
					case(is ValueConstructorDeclaration){
						OpenType constructorTypes =  identificationFactory.forGettableDeclaration(constructor);
						constructorDependency= GettableDependency(constructor,constructorTypes,containerDependency) ;
					}
					value classDefinitnion=identificationFactory.forDeclaration(declaration);
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
