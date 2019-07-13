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
shared class CallableConstructorInjection(CallableConstructor<Object> model,{Dependency*} parameters) extends Injection(){
	shared actual Object inject {
		log.debug("Injecting into: ``model``, parameters: ``parameters`` `");
		value resolvedParameters=parameters.map((Dependency element) => element.resolve)
				.filter((Anything element) => !element is Defaulted);
		log.trace("Resolved parameters: ``resolvedParameters`` for injecting into:``model`` ");
		return model.apply(*resolvedParameters);
	}
	
}