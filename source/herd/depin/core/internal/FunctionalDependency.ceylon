import herd.depin.core {
	log,
	Dependency
}


import herd.depin.core.internal.util {

	invoke,
	safe
}
class FunctionalDependency(
	Dependency.Definition definition,
	Dependency? container,
	{Dependency*} parameters
) extends Dependency(definition,container,parameters){
	
	shared actual Anything resolve{
		log.trace("Resolving functional dependency: ``definition``");
		value resolvedParameters = parameters.collect((Dependency element) => safe(()=> element.resolve)
			((Throwable error) => ResolutionError("Error durring parameter resolution for: ``element`` in ``this``",error)))
				.filter((Anything element) =>!element is Defaulted).sequence();
		log.trace("[Resolved] functional parameters:``resolvedParameters`` for definition: ``definition``");
		value resolvedContainer=safe(()=>container?.resolve)
		((Throwable error) => ResolutionError("Error durring container resolution for: ``container else "null"`` in ``this``",error));
		value it = safe(()=> invoke(definition.declaration,resolvedContainer,resolvedParameters))
		((Throwable error)=>ResolutionError("Invocation for dependency ``definition`` failed for container ``resolvedContainer else "null"`` and parameters ``resolvedParameters``",error));
		log.debug("[Resolved] functional dependency ``it else "null"``, for definition: ``definition``");
		 return it;
	}
	
	
}