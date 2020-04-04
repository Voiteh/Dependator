import herd.depin.core {
	log,
	Dependency
}


import herd.depin.core.internal.util {

	invoke,
	safe
}
import ceylon.language.meta.declaration {
	FunctionalDeclaration,
	NestableDeclaration
}
import herd.depin.core.internal {
	Defaulted
}
shared class FunctionalDependency(
	String name,
	TypeIdentifier identifier,
	FunctionalDeclaration&NestableDeclaration declaration,
	 Dependency? container,
	{Dependency*} parameters
) extends ContainableDependency(name,identifier,declaration,container) {
	
	shared actual Anything resolve{
		log.trace("Resolving functional dependency: ``identifier``");
		value resolvedParameters = parameters.collect((Dependency element) => safe(()=> element.resolve)
			((Throwable error) => ResolutionError("Error durring parameter resolution for: ``element`` in ``this``",error)))
				.filter((Anything element) =>!element is Defaulted).sequence();
		log.trace("[Resolved] functional parameters:``resolvedParameters`` for definition: ``identifier``");
		value resolvedContainer=safe(()=>container?.resolve)
		((Throwable error) => ResolutionError("Error durring container resolution for: ``container else "null"`` in ``this``",error));
		value it = safe(()=> invoke(declaration,resolvedContainer,resolvedParameters))
		((Throwable error)=>ResolutionError("Invocation for dependency ``identifier`` failed for container ``resolvedContainer else "null"`` and parameters ``resolvedParameters``",error));
		log.debug("[Resolved] functional dependency ``it else "null"``, for definition: ``identifier``");
		 return it;
	}
	
	
}