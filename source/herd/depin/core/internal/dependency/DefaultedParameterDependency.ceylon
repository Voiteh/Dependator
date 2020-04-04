
import herd.depin.core {
	log,
	Dependency
}
import ceylon.language.meta.declaration {
	FunctionOrValueDeclaration
}
import herd.depin.core.internal {
	defaulted
}




shared class DefaultedParameterDependency(
	String name,
	TypeIdentifier types,
 	FunctionOrValueDeclaration  declaration,
 	Tree tree
 ) extends ParameterDependency(name,types,declaration,tree){
		
	shared actual Anything resolve{
		log.trace("Resolving defaulted parameter dependency: ``types``");
		Dependency? dependency=provide;
		if(exists dependency){
			Anything resolve=doResolve(dependency);
			log.debug("[Resolved] defaulted parameter dependency: `` resolve else "null" ``, for definition: ``types``");
			return resolve;
		}
		log.trace("[Resolved] defaulted parameter dependency: ``types`` to ``defaulted``");
		return defaulted;
	}
}