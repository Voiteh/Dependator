import ceylon.language.meta.model {
	Function,
	FunctionModel,
	CallableConstructor,
	Method,
	MemberClassCallableConstructor
}

import herd.depin.api {
	Injection,
	Dependency
}
import herd.depin.engine.dependency {
	Defaulted
}
import herd.depin.engine {

	log
}

import ceylon.language.meta.declaration {

	FunctionOrValueDeclaration
}
import herd.depin.engine.meta {

	Validator,
	apply
}
shared class FunctionModelInjection(FunctionModel<> model,Dependency? container,{Dependency*} parameters) extends Injection(){
	value validator=Validator{
		containerDeclaration = container?.definition?.declaration;
		parameterDeclarations = parameters.map((Dependency element) => element.definition.declaration)
				.narrow<FunctionOrValueDeclaration>().sequence();
	};
	shared actual Anything inject {
		log.debug("[Injecting] into: ``model``, parameters: ``parameters`` for container `` container else "null" ``");
		value resolvedContainer= if(exists container ) then container.resolve else null;
		log.trace("[Resolved] container: ``resolvedContainer else "null"`` for injecting into: ``model`` ");
		value resolvedParameters = parameters.map((Dependency element) => element.resolve).select((Anything element) => !element is Defaulted);
		log.trace("[Resolved] parameters: ``resolvedParameters`` for injecting into:``model`` ");	
		validator.validate(resolvedContainer, resolvedParameters);
		switch(model)
		case (is Function<>| CallableConstructor<>|Method<>|MemberClassCallableConstructor<>) {
			return apply(model,resolvedContainer,resolvedParameters);
		}
		else{
			throw Exception("unhandled model type ``model``");
		}
		
	}
	
}