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
shared class MemberValueInjection(MemberClassValueConstructor<> model,Dependency container) extends Injection(){
	shared actual Object inject {
		log.debug("Injecting into : ``model`` with container: ``container``");
		value resolvedContainer = container.resolve;
		log.trace("Resolved container: ``resolvedContainer else "null"`` for injecting into: ``model`` ");
		return model.bind(resolvedContainer).get();
	}

}