import ceylon.language.meta.model {
	MemberClassValueConstructor
}
import herd.depin.api {
	Dependency,
	Injection
}
import herd.depin.engine {

	log
}
import herd.depin.engine.meta {

	Validator,
	apply
}
shared class MemberValueInjection(MemberClassValueConstructor<> model,Dependency container) extends Injection(){
	Validator validator=Validator(container.definition.declaration);
		
	shared actual Object inject {
		log.debug("[Injecting] into : ``model`` with container: ``container``");
		value resolvedContainer = container.resolve;
		log.trace("Resolved container: ``resolvedContainer else "null"`` for injecting into: ``model`` ");
		validator.validate(resolvedContainer);
		return apply(model,resolvedContainer);
	}

}