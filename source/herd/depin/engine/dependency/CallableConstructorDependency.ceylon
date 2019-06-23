import ceylon.language.meta.declaration {
	NestableDeclaration,
	CallableConstructorDeclaration
}

import herd.depin.api {
	Dependency,
	Definition
}
shared class CallableConstructorDependency(CallableConstructorDeclaration declaration,Definition definition) extends Dependency(declaration,definition){
	shared actual Anything provide(Provider provider) {
		value parameters = declarationParameters(declaration.parameterDeclarations,provider);
				
		if(declaration.container.container is NestableDeclaration){
			assert(is Object container = provider.provide(declaration.container));
			return safe(declaration.memberInvoke)([container,[],*parameters])
			((Exception cause)=>Error.memberParameters(declaration,container,parameters,cause));

		}
		return safe(declaration.invoke)([[],*parameters])
		((Exception cause)=> Error.parameters(declaration,parameters,cause));
	}
	
	
}