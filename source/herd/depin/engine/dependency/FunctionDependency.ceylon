import ceylon.language.meta.declaration {
	NestableDeclaration,
	FunctionOrValueDeclaration,
	FunctionDeclaration
}

import herd.depin.api {
	Dependency,
	Definition
}
shared class FunctionDependency(FunctionDeclaration declaration,Definition definition) extends Dependency(declaration,definition){
	shared actual Anything provide(Provider provider) {
		value parameters = declaration.parameterDeclarations
				.map((FunctionOrValueDeclaration element) => element->provider.provide(element))
				.filter((FunctionOrValueDeclaration elementKey -> Anything elementItem) => !elementKey.defaulted || elementItem exists)
				.collect((FunctionOrValueDeclaration elementKey -> Anything elementItem) => elementItem);
		if(is NestableDeclaration containerDeclaration=declaration.container){
			assert(exists container = provider.provide(containerDeclaration));
			try{
				return declaration.memberInvoke(container,[],*parameters);
			}catch(Exception x){
				throw Error.memberParameters(declaration,container,parameters,x);
			}
		}else{
			try{
				return declaration.invoke([],*parameters);
			}catch(Exception x){
				throw Error.parameters(declaration,parameters,x);
			}
		}
	}
}