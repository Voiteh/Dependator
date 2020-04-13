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
	FactorizationError,
	NamedAnnotation
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
			dependency=CollectorDependency{ 
				name = ""; 
				declaration = declaration; 
				types = types; 
				collectedType = collectedType; 
				tree = tree;
				
			};					
		}
		else{
			String name=dependencyName(declaration);
		 	dependency=if(declaration.defaulted) then DefaultedParameterDependency{ 
				name=name;
				declaration = declaration; 
				types = types; 
				tree = tree;
				
			} else ParameterDependency{ 
				name = name; 
				identifier = types; 
				declaration = declaration; 
				tree = tree; 
			};
		}
		return dependency;
	}
	
	throws(`class FactorizationError`,"Could not create dependency")
	shared Dependency create(NestableDeclaration declaration) {
		Dependency dependency;
		String name=dependencyName(declaration);
		if(is FunctionOrValueDeclaration declaration, declaration.parameter){
			dependency=createParameter(declaration);
		}
		else{
			Dependency? containerDependency ;
			if(declaration.formal){
				throw FactorizationError(declaration,"Can't create dependency out of formal declaration");
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
				dependency= FunctionalDependency{ 
					name = name; 
					identifier = identification; 
					declaration = declaration; 
					container = containerDependency; 
					parameters = parameterDependencies;
				};
				
			}
			else case (is ValueDeclaration) {
				TypeIdentifier typeIdentifier =  identificationFactory.create(declaration);
				dependency= GettableDependency{ 
					name = name; 
					identifier = typeIdentifier; 
					declaration = declaration; 
					container = containerDependency;
				};
	
			}
			else case (is ClassDeclaration) {
				if(declaration.abstract){
					throw FactorizationError(declaration,"Can't create dependency out of abstract class");
				}
				else if (exists anonymousObjectDeclaration = declaration.objectValue) {
					TypeIdentifier typeIdentifier =  identificationFactory.create(anonymousObjectDeclaration);
					dependency= GettableDependency{ 
						name = name; 
						identifier = typeIdentifier; 
						declaration = anonymousObjectDeclaration; 
						container = containerDependency;
						
					};
				} else { 
					value constructor = targetSelector.select(declaration);
					
					Dependency constructorDependency;
					switch(constructor) 
					case(is CallableConstructorDeclaration ){
						TypeIdentifier identifier =  identificationFactory.create(constructor);
						value parameterDependencies = constructor.parameterDeclarations
								.collect((FunctionOrValueDeclaration element) => create(element));
						constructorDependency= FunctionalDependency{ 
							name = name; 
							identifier = identifier; 
							declaration = constructor; 
							container = containerDependency; 
							parameters = parameterDependencies; 
						};
					}
					case(is ValueConstructorDeclaration){
						TypeIdentifier typeIdentifier =  identificationFactory.create(constructor);
						constructorDependency= GettableDependency{
							 name = name; 
							 identifier = typeIdentifier; 
							 declaration = constructor; 
							 container = containerDependency;
							
						};
					}
					value typeIdentifier=identificationFactory.create(declaration);
					dependency=ClassDependency{ 
						name = name; 
						identification = typeIdentifier; 
						declaration = declaration; 
						constructorDependency = constructorDependency;
						
					};
				}
			}
			else {
				throw FactorizationError(declaration, "Not supported");
			}
		}
		log.debug("[Created Dependency]: ``dependency``, for declaration: ``declaration``");
		return dependency;
	}
	
	shared String dependencyName(NestableDeclaration declaration) {
		variable String? result;
		try {
			if (exists namedAnnotation = declaration.annotations<NamedAnnotation>().first) {
				result = namedAnnotation.name;
			} else {
				switch (declaration)
				case (is ClassDeclaration) {
					assert (exists value first = declaration.name.first?.lowercased);
					value newName = String({ first,
						*declaration.name.rest });
					result = newName;
				}
				case (is CallableConstructorDeclaration) {
					assert (exists value first = declaration.container.name.first?.lowercased);
					if (declaration.name.empty) {
						value newName = String({ first,
							*declaration.container.name.rest });
						result = newName;
					} else {
						result = declaration.name;
					}
				}
				else {
					result = declaration.name;
				}
			}
		} catch (Throwable x) {
			//Ceylon BUG (https://github.com/eclipse/ceylon/issues/7448)!!!
			//We can't identifiy parameter by annotations but for now we can use name of the parameter.
			//This will be enough for most of cases. 
			result = declaration.name;
		}
		assert (exists shadow = result);
		return shadow;
	}
}
