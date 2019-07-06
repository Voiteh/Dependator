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
shared class CallableConstructorInjection(CallableConstructor<Object> model,{Dependency*} parameters) extends Injection(){
	shared actual Object inject {
		value resolved=parameters.map((Dependency element) => element.resolve)
				.filter((Anything element) => !element is Defaulted);
		return model.apply(*resolved);
	}
	
}