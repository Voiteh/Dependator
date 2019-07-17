import herd.depin.api {
	Dependency
}
import ceylon.language.meta.declaration {
	FunctionalDeclaration
}
import herd.depin.engine {

	log,
	safe
}
shared class FunctionalDependency(
	FunctionalDeclaration declaration,
	Dependency.Definition definition,
	Dependency? container,
	{Dependency*} parameters,
	{Dependency.Decorator*} decorators
) extends Dependency(definition,container,parameters,decorators){
	shared actual Anything resolve{
		log.trace("Resolving functional dependency: ``definition``");
		value resolvedParameters = parameters.collect((Dependency element) => safe(()=> element.resolve)
			((Throwable error) => ResolutionError("Error durring parameter resolution for: ``element`` in ``this``",error)))
				.filter((Anything element) =>!element is Defaulted);
		log.trace("Resolved functional parameters:``resolvedParameters`` for definition: ``definition``");
		if(exists resolved=safe(()=>container?.resolve)
			((Throwable error) => ResolutionError("Error durring container resolution for: ``container else "null"`` in ``this``",error))){
			log.trace("Resolved functional dependency container: ``resolved``, for definition: ``definition``");
			value resolvedMember = safe(()=> declaration.memberInvoke(resolved,[], *resolvedParameters))
			((Throwable error) => ResolutionError("Error durring dependency resolution for container: ``container else "null"`` and parameters: ``parameters``",error));
			log.debug("Resolved functional member dependency: ``resolvedMember else "null"``, for definition``definition``");
			return resolvedMember;
		}
		 value invoke = safe(()=>declaration.invoke([],*resolvedParameters))
		 ((Throwable error) => ResolutionError("Error durring dependency resolution for parameters: ``parameters``",error));
		 log.debug("Resolved functional dependency ``invoke else "null"``, for definition``definition``");
		 return invoke;
	}
	
	
}