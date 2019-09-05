
import herd.depin.engine {

	log,
	Dependency,
	Injection
}
import ceylon.language.meta.model {

	Gettable,
	ValueModel
}
import herd.depin.engine.meta {

	apply
}
shared class GettableInjection(Gettable<>&ValueModel<> model,Dependency? container=null) extends Injection(){
	value validator=Validator(model.container);
	
	shared actual Anything inject {
		log.debug("[Injecting] into: ``model`` with container ``container else "null"``");
		value resolvedContainer=if(exists container) then container.resolve else null;
	  	validator.validate(resolvedContainer);
		return apply(model,resolvedContainer);
		
	}
	
	
}