import herd.depin.api {
	Injection,
	Dependency
}
import ceylon.language.meta.model {
	MemberClassCallableConstructor
}
import herd.depin.engine.dependency {
	Defaulted
}
import herd.depin.engine {

	log
}
shared class MemberCallableConstructorInjection(MemberClassCallableConstructor<> model,Dependency container,{Dependency*} parameteres) extends Injection(){
	shared actual Object inject {
		log.debug("Injecting into: ``model``, parameters: ``parameteres`` for container ``container`` `");
		value resolvedContainer = container.resolve;
		log.trace("Resolved container: ``resolvedContainer else "null"`` for injecting into: ``model`` ");
		value resolvedParameters = parameteres.map((Dependency element) => element.resolve).filter((Anything element) => !element is Defaulted);
		log.trace("Resolved parameters: ``resolvedParameters`` for injecting into:``model`` ");
		return model.bind(resolvedContainer).apply(*resolvedParameters);
	}
	
}