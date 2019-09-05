import ceylon.language.meta.model {
	MemberClassValueConstructor
}

import herd.depin.engine {

	log,
	Dependency,
	Injection
}
import herd.depin.engine.meta {

	apply
}
shared class MemberValueInjection(MemberClassValueConstructor<> model,Dependency container) extends Injection(){
	Validator validator=Validator(model.container);
		
	shared actual Object inject {
		log.debug("[Injecting] into : ``model`` with container: ``container``");
		value resolvedContainer = container.resolve;
		log.trace("Resolved container: ``resolvedContainer else "null"`` for injecting into: ``model`` ");
		validator.validate(resolvedContainer);
		assert (exists result=apply(model,resolvedContainer));
		return result;
	}

}