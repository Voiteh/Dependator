import ceylon.language.meta.declaration {
	ValueConstructorDeclaration,
	NestableDeclaration
}

import herd.depin.api {
	Dependency,
	Definition
}
shared class ValueConstructorDepedndency(ValueConstructorDeclaration declaration,Definition definition) extends Dependency(declaration,definition){
	shared actual Anything provide(Dependency.Provider provider){
		if(is NestableDeclaration containerDeclaration=declaration.container.container){
			assert(exists container = provider.provide(containerDeclaration));
			return safe(declaration.memberGet)([container])
			((Exception cause)=>Error.member(declaration,container,cause));
		}
		return safe(declaration.get)([])
		((Exception cause)=>Error(declaration,cause));
	}
	
	
}