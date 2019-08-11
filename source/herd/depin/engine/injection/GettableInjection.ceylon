import herd.depin.api {

	Injection,
	Dependency
}
import herd.depin.engine {

	log
}
import ceylon.language.meta.model {

	Gettable
}
import herd.depin.engine.meta {

	apply,
	Validator
}
shared class GettableInjection(Gettable<> model,Dependency? container=null) extends Injection(){
	value validator=Validator(container?.definition?.declaration);
	
	shared actual Anything inject {
		log.debug("[Injecting] into: ``model`` with container ``container else "null"``");
		value resolvedContainer=if(exists container) then container.resolve else null;
	  	validator.validate(resolvedContainer);
		return apply(model,resolvedContainer);
		
	}
	
	
}