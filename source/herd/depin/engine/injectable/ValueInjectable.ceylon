import ceylon.language.meta.declaration {
	NestableDeclaration,
	ValueDeclaration
}
import herd.depin.api {
	Injectable,
	Creator
}
shared class ValueInjectable(ValueDeclaration declaration) extends Injectable(declaration){
	shared actual Anything inject(Creator injector) {
		if(is NestableDeclaration containerDeclaration=declaration.container){
			assert(exists container = injector.create(containerDeclaration));
			try{
				return declaration.memberGet(container);
			}catch(Exception x){
				throw Error.member(x,container);
			}
		}else{
			try{
				return declaration.get();
			}catch(Exception x){
				throw Error(x);
			}
		}
	}
	
	
	
}