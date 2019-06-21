import ceylon.language.meta.declaration {
	NestableDeclaration,
	FunctionOrValueDeclaration,
	FunctionDeclaration
}
import herd.depin.api {
	Injectable,
	Creator
}
shared class FunctionInjectable(FunctionDeclaration declaration) extends Injectable(declaration){
	shared actual Anything inject(Creator injector) {
		value parameters = declaration.parameterDeclarations
				.map((FunctionOrValueDeclaration element) => element->injector.create(element))
				.filter((FunctionOrValueDeclaration elementKey -> Anything elementItem) => !elementKey.defaulted || elementItem exists)
				.collect((FunctionOrValueDeclaration elementKey -> Anything elementItem) => elementItem);
		if(is NestableDeclaration containerDeclaration=declaration.container){
			assert(exists container = injector.create(containerDeclaration));
			try{
				return declaration.memberInvoke(container,[],parameters);
			}catch(Exception x){
				throw Error.member(x,container,parameters);
			}
		}else{
			try{
				return declaration.invoke([],*parameters);
			}catch(Exception x){
				throw Error(x,parameters);
			}
		}
	}
}