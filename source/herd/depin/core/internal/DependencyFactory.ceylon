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

import herd.depin.core.internal.dependency {
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
	
	shared Dependency createParameter(FunctionOrValueDeclaration declaration){
		Dependency dependency;
		TypeIdentifier types =  identificationFactory.create(declaration);
		if(is OpenClassType collectorType=declaration.openType,collectorType.declaration==`class Collector`){
			assert(exists collectedType=collectorType.typeArgumentList.first);
			dependency=CollectorDependency(declaration,types,collectedType, tree);					
		}
		else if(declaration.defaulted){
			dependency= DefaultedParameterDependency(declaration,types, tree);
		}else{
			dependency=ParameterDependency(declaration,types, tree);
		}
		return dependency;
	}
	
	shared Dependency create(NestableDeclaration declaration) {
		Dependency dependency;
		if(is FunctionOrValueDeclaration declaration, declaration.parameter){
			dependency=createParameter(declaration);
		}
		else{
			Dependency? containerDependency ;
			if(declaration.formal){
				throw Exception("Formal declarations not allowed: ``declaration```");
			}
			if (is NestableDeclaration containerDeclaration = declaration.container) {
				 containerDependency=create(containerDeclaration);
			}else{
				containerDependency=null;
			}
			switch (declaration)
			case (is FunctionalDeclaration) {
				TypeIdentifier identification =  identificationFactory.create(declaration);
				value parameterDependencies = declaration.parameterDeclarations
 						.collect((FunctionOrValueDeclaration element) => create(element));
				dependency= FunctionalDependency(declaration, identification, containerDependency, parameterDependencies);
				
			}
			else case (is ValueDeclaration) {
				TypeIdentifier identification =  identificationFactory.create(declaration);
				dependency= GettableDependency(declaration,identification, containerDependency);
	
			}
			else case (is ClassDeclaration) {
				if(declaration.abstract){
					throw FactorizationError(declaration,"Can't create dependency out of abstract class");
				}
				else if (exists anonymousObjectDeclaration = declaration.objectValue) {
					TypeIdentifier definition =  identificationFactory.create(anonymousObjectDeclaration);
					dependency= GettableDependency(anonymousObjectDeclaration,definition,containerDependency) ;
				} else { 
					value constructor = targetSelector.select(declaration);
					
					Dependency constructorDependency;
					switch(constructor) 
					case(is CallableConstructorDeclaration ){
						TypeIdentifier constructorTypes =  identificationFactory.create(constructor);
						value parameterDependencies = constructor.parameterDeclarations
								.collect((FunctionOrValueDeclaration element) => create(element));
						constructorDependency= FunctionalDependency(constructor, constructorTypes, containerDependency, parameterDependencies);
					}
					case(is ValueConstructorDeclaration){
						TypeIdentifier constructorTypes =  identificationFactory.create(constructor);
						constructorDependency= GettableDependency(constructor,constructorTypes,containerDependency) ;
					}
					value classDefinitnion=identificationFactory.create(declaration);
					dependency=ClassDependency(declaration, classDefinitnion, constructorDependency);
				}
			}
			else {
				throw FactorizationError(declaration, "Not supported");
			}
		}
		log.debug("[Created Dependency]: ``dependency``, for declaration: ``declaration``");
		return dependency;
	}
	
	
}
