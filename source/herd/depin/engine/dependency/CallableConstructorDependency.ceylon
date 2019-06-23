import ceylon.language.meta.declaration {
	NestableDeclaration,
	CallableConstructorDeclaration,
	FunctionOrValueDeclaration
}

import herd.depin.api {
	Dependency,
	Definition
}
shared class CallableConstructorDependency(CallableConstructorDeclaration declaration,Definition definition) extends Dependency(declaration,definition){
	shared actual Anything provide(Provider provider) {
		value parameters = declaration.parameterDeclarations
				.map((FunctionOrValueDeclaration element) => element->provider.provide(element))
				.filter((FunctionOrValueDeclaration elementKey -> Anything elementItem) => !elementKey.defaulted || elementItem exists)
				.collect((FunctionOrValueDeclaration elementKey -> Anything elementItem) => elementItem);
		if(declaration.container.container is NestableDeclaration){
			assert(is Object container = provider.provide(declaration.container));
			try{
				return declaration.memberInvoke(container,[], parameters);
			}catch(Exception x){
				throw Error.memberParameters(declaration,container,parameters,x);
			}
		}
		try{
			return declaration.invoke([],*parameters);
		}catch(Exception x){
			throw Error.parameters(declaration,parameters,x);
		}
	}
	
	
}