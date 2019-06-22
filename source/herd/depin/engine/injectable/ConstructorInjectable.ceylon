import ceylon.language.meta.declaration {
	NestableDeclaration,
	CallableConstructorDeclaration,
	FunctionOrValueDeclaration
}
import herd.depin.api {
	Injectable,
	Creator
}
shared class ConstructorInjectable(CallableConstructorDeclaration declaration) extends Injectable(declaration){
	shared actual Anything inject(Creator injector) {
		value parameters = declaration.parameterDeclarations
				.map((FunctionOrValueDeclaration element) => element->injector.create(element))
				.filter((FunctionOrValueDeclaration elementKey -> Anything elementItem) => !elementKey.defaulted || elementItem exists)
				.collect((FunctionOrValueDeclaration elementKey -> Anything elementItem) => elementItem);
		if(declaration.container.container is NestableDeclaration){
			assert(is Object container = injector.create(declaration.container));
			try{
				return declaration.memberInvoke(container,[], parameters);
			}catch(Exception x){
				throw Error.member(x,container,parameters);
			}
		}
		try{
			return declaration.invoke([],*parameters);
		}catch(Exception x){
			throw Error(x,parameters);
		}
	}
	
	
}