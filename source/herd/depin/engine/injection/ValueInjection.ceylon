import ceylon.language.meta.model {
	ValueConstructor
}

import herd.depin.api {
	Injection
}
shared class ValueConstructorInjection(ValueConstructor<Object> model) extends Injection(){
	shared actual Object inject => model.get();
	
}