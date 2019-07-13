import herd.depin.api {
	Dependency
}
import ceylon.language.meta.declaration {
	FunctionalDeclaration
}
import herd.depin.engine {

	log
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
		value resolvedParameters = parameters.collect((Dependency element) => element.resolve)
				.filter((Anything element) =>!element is Defaulted);
		log.trace("Resolved functional parameters:``resolvedParameters`` for definition: ``definition``");
		if(exists resolved=container?.resolve){
			log.trace("Resolved functional dependency container: ``resolved``, for definition: ``definition``");
			value resolvedMember = declaration.memberInvoke(resolved,[], *resolvedParameters);
			log.debug("Resolved functional member dependency: ``resolvedMember else "null"``, for definition``definition``");
			return resolvedMember;
		}
		 value invoke = declaration.invoke([],*resolvedParameters);
		 log.debug("Resolved functional dependency ``invoke else "null"``, for definition``definition``");
		 return invoke;
	}
	
	
}