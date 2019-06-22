import ceylon.language.meta.declaration {
	Declaration,
	FunctionDeclaration,
	ValueDeclaration,
	CallableConstructorDeclaration,
	ClassDeclaration,
	ConstructorDeclaration,
	GenericDeclaration
}

import herd.depin.api {
	Provider,
	Injectable,
	Dependency,
	Registry
}
import herd.depin.engine.injectable {
	ConstructorInjectable,
	FunctionInjectable,
	ValueInjectable
}
shared class DefaultProvider(Registry registry) satisfies Provider{
	shared actual Injectable provide(Declaration declaration, Dependency dependency) {
		if(is GenericDeclaration declaration,!declaration.typeParameterDeclarations.empty){
			throw Exception("Type parameters are not supported yet in dependencies ``declaration``");
		}
		switch(declaration)
		case (is FunctionDeclaration) {
			return FunctionInjectable(declaration);
		}
		case( is ValueDeclaration){
			return ValueInjectable(declaration);
		}
		case (is CallableConstructorDeclaration){
			return ConstructorInjectable(declaration);
		}
		case (is ClassDeclaration){
			if(exists defaultConstructor= declaration.defaultConstructor){
				return ConstructorInjectable(defaultConstructor);
			}
			ConstructorDeclaration[] constructors=declaration.constructorDeclarations().select((ConstructorDeclaration element) => element.annotated<TargetAnnotation>());
			if(constructors.size==0){
				throw Exception("Can't select injection target, no default constructor or annotated `` `class TargetAnnotation` ``");
			}
			else if(constructors.size>1){
				throw Exception("Can't select injection target, multiple constructors annotated `` `class TargetAnnotation` ``");
			}
			assert(is CallableConstructorDeclaration targetConstructor=constructors.first);
			return ConstructorInjectable(targetConstructor);
		}
		else{ 
			throw Exception("Declaration ``declaration``not supported ");
		}
	}
		
}

