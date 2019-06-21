import ceylon.language.meta.declaration {
	Declaration,
	FunctionOrValueDeclaration,
	FunctionDeclaration,
	ValueDeclaration,
	CallableConstructorDeclaration,
	ClassDeclaration,
	NestableDeclaration,
	ConstructorDeclaration,
	GenericDeclaration
}

import herd.depin.api {
	Provider,
	Injectable,
	Dependency,
	Registry,
	Creator
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
			value constructors=declaration.constructorDeclarations().select((ConstructorDeclaration element) => element.annotated<TargetAnnotation>());
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
class ConstructorInjectable(CallableConstructorDeclaration declaration) extends Injectable(declaration){
	shared actual Anything inject(Creator injector) {
		value parameters = declaration.parameterDeclarations.collect((FunctionOrValueDeclaration element) => injector.create(element));
		if(declaration.container.container is NestableDeclaration){
			assert(is Object container = injector.create(declaration.container));
			return declaration.memberInvoke(container,[], parameters);
		}

		return declaration.invoke([],*parameters);
	}
	
	
}
class FunctionInjectable(FunctionDeclaration declaration) extends Injectable(declaration){
	shared actual Anything inject(Creator injector) {
		value parameters = declaration.parameterDeclarations.collect((FunctionOrValueDeclaration element) => injector.create(element));
		if(is NestableDeclaration containerDeclaration=declaration.container){
			assert(exists container = injector.create(containerDeclaration));
			return declaration.memberInvoke(container,[],parameters);
		}else{
			return declaration.invoke([],*parameters);
		}
	}
	
	
}
class ValueInjectable(ValueDeclaration declaration) extends Injectable(declaration){
	shared actual Anything inject(Creator injector) {
		if(is NestableDeclaration containerDeclaration=declaration.container){
			assert(exists container = injector.create(containerDeclaration));
			return declaration.memberGet(container);
		}else{
			return declaration.get();
		}
	}

	
	
}
