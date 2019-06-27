import ceylon.language.meta.declaration {
	Declaration,
	CallableConstructorDeclaration,
	GenericDeclaration,
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration,
	ConstructorDeclaration,
	ValueConstructorDeclaration,
	AnnotatedDeclaration
}

import herd.depin.api {
	Dependency,
	Definition,
	DependencyAnnotation,
	singleton,
	prototype
}

shared class DependencyFactory(Definition.Factory factory) satisfies Dependency.Factory {
	shared actual Dependency create(Declaration declaration) {
		
		if (is GenericDeclaration declaration, !declaration.typeParameterDeclarations.empty) {
			throw Exception("Type parameters are not supported yet in dependency: ``declaration``");
		}
		value dependency = prepare(declaration);

		if (is AnnotatedDeclaration declaration, exists dependencyAnnotation = declaration.annotations<DependencyAnnotation>().first) {
			switch(provision=dependencyAnnotation.provision)
			case(singleton){
				return SingletonDecorator(dependency);
			}
			case (prototype){
				return dependency;
			}

		}else{
			return SingletonDecorator(dependency);
		}
	}
	
	Dependency prepare(Declaration declaration) {
		value definition = factory.create(declaration);
		switch (declaration)
		case (is FunctionDeclaration) {
			return FunctionDependency(declaration, definition);
		}
		case (is ValueDeclaration) {
			return ValueDependency(declaration, definition);
		}
		case (is ClassDeclaration) {
			variable ConstructorDeclaration constructor;
			if (declaration.annotated<DependencyAnnotation>()) {
				if (declaration.constructorDeclarations().find((ConstructorDeclaration elem) => elem.annotated<DependencyAnnotation>()) exists) {
					throw Exception("Either class (for initializer definition) or single constructor may be annotatated with `` `class DependencyAnnotation` ``, never both!");
				}
				assert (exists defaultConstructor = declaration.defaultConstructor);
				constructor=defaultConstructor;
			}
			else if(exists singleConstructor=declaration.constructorDeclarations().first,declaration.constructorDeclarations().rest.empty){
				constructor=singleConstructor;
			}
			else{
				value constructors = declaration.constructorDeclarations().filter((ConstructorDeclaration elem) => elem.annotated<DependencyAnnotation>());
				if (!constructors.rest.empty) {
					throw Exception("Only one constructor may be annotated `` `class DependencyAnnotation` ``");
				}
				assert (exists annotatedConstructor= constructors.first);
				constructor=annotatedConstructor;
				
			}	
			switch (constructorDeclaration = constructor)
			case (is CallableConstructorDeclaration) {
				return CallableConstructorDependency(constructorDeclaration, definition);
			}
			case (is ValueConstructorDeclaration) {
				return ValueConstructorDepedndency(constructorDeclaration, definition);
			}
		}
		else {
			throw Exception("Declaration ``declaration`` not supported ");
		}
	}
}
