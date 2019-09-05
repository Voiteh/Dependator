import ceylon.language.meta.model {
	ValueConstructor
}


import herd.depin.engine {

	log,
	Injection
}
import herd.depin.engine.meta {

	apply
}
shared class ValueConstructorInjection(ValueConstructor<Object> model) extends Injection(){
	shared actual Object inject {
		log.debug("[Injecting] into: ``model``");
		assert (is Object result =apply(model));
		return result;
	}
	
}