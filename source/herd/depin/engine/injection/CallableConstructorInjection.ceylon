import ceylon.language.meta.model {
	CallableConstructor
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
shared class CallableConstructorInjection(CallableConstructor<Object> model,{Dependency*} parameters) extends Injection(){
	value validator=Validator{
		parameterDeclarations = parameters.map((Dependency element) => element.definition.declaration)
				.narrow<FunctionOrValueDeclaration>().sequence();
	};
	shared actual Object inject {
		log.debug("[Injecting] into: ``model``, parameters: ``parameters`` `");
		value resolvedParameters=parameters.map((Dependency element) => element.resolve)
				.select((Anything element) => !element is Defaulted);
		log.trace("Resolved parameters: ``resolvedParameters`` for injecting into:``model`` ");
		validator.validate(null,resolvedParameters);
		assert(is Object result= apply(model, null, resolvedParameters));
		return result;
	}
	
}