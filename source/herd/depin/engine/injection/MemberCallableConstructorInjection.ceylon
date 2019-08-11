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
import herd.depin.engine.meta {

	Validator,
	apply
}
import ceylon.language.meta.declaration {

	FunctionOrValueDeclaration
}
shared class MemberCallableConstructorInjection(MemberClassCallableConstructor<> model,Dependency container,{Dependency*} parameteres) extends Injection(){
	Validator validator=Validator{
		containerDeclaration = container.definition.declaration;
		parameterDeclarations =parameteres.map((Dependency element) => element.definition.declaration)
				.narrow<FunctionOrValueDeclaration>()
				.sequence();
	};
	shared actual Object inject {
		log.debug("[Injecting] into: ``model``, parameters: ``parameteres`` for container ``container`` `");
		value resolvedContainer = container.resolve;
		log.trace("Resolved container: ``resolvedContainer else "null"`` for injecting into: ``model`` ");
		value resolvedParameters = parameteres.map((Dependency element) => element.resolve).select((Anything element) => !element is Defaulted);
		log.trace("Resolved parameters: ``resolvedParameters`` for injecting into:``model`` ");
		validator.validate(resolvedContainer, resolvedParameters);
		 assert(exists result = apply(model,resolvedContainer,resolvedParameters));
		 return result;
	}
	
}