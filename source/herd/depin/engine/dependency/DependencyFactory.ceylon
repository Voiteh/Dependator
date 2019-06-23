import ceylon.language.meta.declaration {
	Declaration,
	CallableConstructorDeclaration,
	GenericDeclaration,
	FunctionDeclaration,
	ValueDeclaration,
	ClassDeclaration,
	ConstructorDeclaration,
	ValueConstructorDeclaration
}

import herd.depin.api {
	Dependency,
	Definition,
	DependencyAnnotation
}

shared class DependencyFactory(Definition.Factory factory) satisfies Dependency.Factory{
	shared actual Dependency create(Declaration declaration) {
		if(is GenericDeclaration declaration,!declaration.typeParameterDeclarations.empty){
			throw Exception("Type parameters are not supported yet in dependencies ``declaration``");
		}
		value definition=factory.create(declaration);
		switch(declaration)
		case (is FunctionDeclaration) {
			return FunctionDependency(declaration,definition);
		}
		case( is ValueDeclaration){
			return ValueDependency(declaration,definition);
		}
		
		case (is ClassDeclaration){
			if(declaration.annotated<DependencyAnnotation>()){
				if(declaration.constructorDeclarations().find((ConstructorDeclaration elem) => elem.annotated<DependencyAnnotation>()) exists){
					throw Exception("Either class (for initializer definition) or single constructor must be annotatated with `` `class DependencyAnnotation` ``, never both!");
				}
				assert(exists defaultConstructor=declaration.defaultConstructor);
				return CallableConstructorDependency(defaultConstructor, definition);
			}
			value constructors=declaration.constructorDeclarations().filter((ConstructorDeclaration elem) => elem.annotated<DependencyAnnotation>());
			if(!constructors.rest.empty){
				throw Exception("Only one constructor may be annotated `` `class DependencyAnnotation` ``");
			}
			assert(exists constructor=constructors.first);
			switch(constructor)
			case(is CallableConstructorDeclaration ){
				return CallableConstructorDependency(constructor, definition);
			}case(is ValueConstructorDeclaration){
				return ValueConstructorDepedndency(constructor, definition);
			}
		}
		else {
			throw Exception("Declaration ``declaration`` not supported ");
		}
		
	}
	
	
}