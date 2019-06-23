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