import ceylon.language.meta.model {
	CallableConstructor
}


import herd.depin.engine.dependency {
	Defaulted
}
import herd.depin.engine {

	log,
	Dependency,
	Injection
}

import herd.depin.engine.meta {
	apply
}
shared class CallableConstructorInjection(CallableConstructor<Object> model,{Dependency*} parameters) extends Injection(){
	value validator=Injection.Validator{
		parameterTypes =  model.parameterTypes;
	};
	shared actual Object inject {
		log.debug("[Injecting] into: ``model``, parameters: ``parameters`` `");
		value resolvedParameters=parameters.map((Dependency element) => element.resolve)
				.select((Anything element) => !element is Defaulted);
		log.trace("[Resolved] parameters: ``resolvedParameters`` for injecting into:``model`` ");
		validator.validate(null,resolvedParameters);
		assert(is Object result= apply(model, null, resolvedParameters));
		return result;
	}
	
}