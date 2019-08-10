import ceylon.language.meta.declaration {
	FunctionOrValueDeclaration
}

import herd.depin.api {
	Dependency
}
import herd.depin.engine {
	log,
	safe
}

import herd.depin.engine.meta {

	invoke,
	Validator
}
shared class FunctionalDependency(
	Dependency.Definition definition,
	Dependency? container,
	{Dependency*} parameters,
	{Dependency.Decorator*} decorators
) extends Dependency(definition,container,parameters,decorators){
	value validator=Validator{
		containerDeclaration = container?.definition?.declaration;
		parameterDeclarations = parameters.map((Dependency element) => element.definition.declaration)
				.narrow<FunctionOrValueDeclaration>().sequence();
	};
	shared actual Anything resolve{
		log.trace("Resolving functional dependency: ``definition``");
		value resolvedParameters = parameters.collect((Dependency element) => safe(()=> element.resolve)
			((Throwable error) => ResolutionError("Error durring parameter resolution for: ``element`` in ``this``",error)))
				.filter((Anything element) =>!element is Defaulted).sequence();
		log.trace("Resolved functional parameters:``resolvedParameters`` for definition: ``definition``");
		value resolvedContainer=safe(()=>container?.resolve)
		((Throwable error) => ResolutionError("Error durring container resolution for: ``container else "null"`` in ``this``",error));
		validator.validate(resolvedContainer, resolvedParameters);
		value it = invoke(definition.declaration,resolvedContainer,resolvedParameters);
		log.debug("Resolved functional dependency ``it else "null"``, for definition``definition``");
		 return it;
	}
	
	
}