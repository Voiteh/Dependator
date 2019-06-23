import ceylon.language.meta.declaration {
	NestableDeclaration,
	ValueDeclaration
}

import herd.depin.api {
	Dependency,
	Definition
}
shared class ValueDependency(ValueDeclaration declaration,Definition definition) extends Dependency(declaration,definition){
	shared actual Anything provide(Provider provider) {
		if(is NestableDeclaration containerDeclaration=declaration.container){
			assert(exists container = provider.provide(containerDeclaration));
			return safe(declaration.memberGet)([container])
			((Exception cause)=>Error.member(declaration,container,cause));

		}
		return safe(declaration.get)([])
		((Exception cause)=> Error(declaration,cause));
		
		
	}
	
	
	
}