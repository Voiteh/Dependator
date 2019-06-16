import herd.depin.api {
	Injection,
	Provider
}
import ceylon.language.meta.declaration {
	CallableConstructorDeclaration,
	FunctionOrValueDeclaration
}
import ceylon.language.meta {
	type
}
import ceylon.language.meta.model {
	CallableConstructor
}
shared class ConstructorInjection(CallableConstructorDeclaration declaration) extends Injection(){
	shared actual Anything provide(Provider provider) {
		if(!declaration.typeParameterDeclarations.empty){
			throw Error("Type parameter not supported yet for classes");
		}
		CallableConstructor<> constructor;
		if(!declaration.toplevel){
			assert(is Object container = provider.provide(declaration.container));
			value memberConstructor=reThrow(()=>declaration.memberApply<>(type(container)),"Couldn't provide constructor ``declaration``");
			constructor = reThrow(()=>memberConstructor.bind(container),"Couldn't provide constructor ``declaration``");
		}else{
			constructor=reThrow(()=> declaration.apply(),"Couldn't provide constructor ``declaration``");
		}
		value parameters = declaration.parameterDeclarations.map((FunctionOrValueDeclaration element) => provider.provide(element));
		return reThrow(()=> constructor.apply(parameters),"Couldn't provide constructor ``declaration``");
	}
	
}