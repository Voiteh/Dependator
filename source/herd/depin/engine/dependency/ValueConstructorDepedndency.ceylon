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
			try{
				return declaration.memberGet(container);
			}catch(Exception x){
				throw Error.member(declaration,container,x);
			}
		}else{
			try{
				return declaration.get();
			}catch(Exception x){
				throw Error(declaration,x);
			}
		}
	}
	
	
}