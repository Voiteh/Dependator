import herd.depin.api {
	Dependency
}
import herd.depin.engine {
	log
}

import herd.depin.engine.meta {

	invoke,
	Validator
}
shared class ValueDependency(
	Dependency.Definition definition,
	Dependency? container,
	{Dependency.Decorator*} decorators
) extends Dependency(definition,container,empty,decorators){
	
	value validator=Validator(container?.definition?.declaration);
	
	shared actual Anything resolve {
		if(exists container, exists resolved=container.resolve){
			validator.validate(resolved);
			value result=invoke(definition.declaration, resolved);
			log.debug("Resolved value member dependency ``result else "null"`` for definition ``definition`` and container ``container``");
			return result;
		}
		value result=invoke(definition.declaration);
		log.debug("[Registered] value dependency: ``result else "null"``, for definition: ``definition``");
		return result;
	}
		
}