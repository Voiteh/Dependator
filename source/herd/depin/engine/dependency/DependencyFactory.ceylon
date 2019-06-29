import ceylon.language.meta.declaration {
	Declaration,
	CallableConstructorDeclaration,
	GenericDeclaration,
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration,
	ConstructorDeclaration,
	ValueConstructorDeclaration,
	AnnotatedDeclaration,
	NestableDeclaration,
	FunctionOrValueDeclaration
}

import herd.depin.api {
	Dependency,
	Definition,
	DependencyAnnotation,
	singleton,
	prototype,
	TargetAnnotation
}

shared class DependencyFactory(Definition.Factory factory) satisfies Dependency.Factory {
	shared actual {Dependency+} create(FunctionOrValueDeclaration declaration) {
		
		if (is GenericDeclaration declaration, !declaration.typeParameterDeclarations.empty) {
			throw Exception("Type parameters are not supported yet in dependency: ``declaration``");
		}
		return nestableDeclarations(declaration)
				.map(prepare)
				.map(decorate);
	}
	Dependency decorate(Dependency dependency) {
		if (is AnnotatedDeclaration declaration = dependency.declaration, exists dependencyAnnotation = declaration.annotations<DependencyAnnotation>().first) {
			switch (provision = dependencyAnnotation.provision)
			case (singleton) {
				return SingletonDecorator(dependency);
			}
			case (prototype) {
				return dependency;
			}
		} else {
			return SingletonDecorator(dependency);
		}
	}
	
	{NestableDeclaration+} nestableDeclarations(NestableDeclaration declaration) {
		if (is NestableDeclaration container = declaration.container) {
			return { declaration, *nestableDeclarations(container) };
		}
		return { declaration };
	}
	
	Dependency prepare(Declaration declaration) {
		Definition definition = factory.create(declaration);
		switch (declaration)
		case (is FunctionDeclaration) {
			return FunctionDependency(declaration, definition);
		}
		case (is ValueDeclaration) {
			return ValueDependency(declaration, definition);
		}
		case (is ClassDeclaration) {
			if(exists anonymousObject= declaration.objectValue){
				return prepare(anonymousObject);
			}
			variable ConstructorDeclaration constructor;
			value annotated = declaration.constructorDeclarations().select((ConstructorDeclaration element) => element.annotated<TargetAnnotation>());
			if (exists selected = annotated.first) {
				if (annotated.rest.empty) {
					constructor = selected;
				} else {
					throw FactorizationError {
						declaration = declaration;
						message = "Only one constructor may be annotated `` `class TargetAnnotation` ``, found: ``annotated``";
					};
				}
			} else if (exists default = declaration.defaultConstructor) {
				constructor = default;
			} else {
				throw FactorizationError { 
					declaration = declaration;
					message = "Either single constructor must be annotated with `` `class TargetAnnotation` ``
					            or default constructor must be defined, not both! Found: ``annotated``"; };
	
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
				throw FactorizationError(declaration, "not supported ");
			}
		}
	}