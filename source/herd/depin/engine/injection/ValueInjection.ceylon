import ceylon.language.meta.model {
	ValueConstructor
}

import herd.depin.api {
	Injection
}
import herd.depin.engine {

	log
}
shared class ValueConstructorInjection(ValueConstructor<Object> model) extends Injection(){
	shared actual Object inject {
		log.debug("[Injecting] into: ``model``");
		return model.get();
	}
	
}