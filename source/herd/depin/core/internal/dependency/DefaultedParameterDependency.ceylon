
import herd.depin.core {
	log,
	Dependency
}
import ceylon.language.meta.declaration {
	FunctionalDeclaration,
	NestableDeclaration,
	GettableDeclaration
}
import herd.depin.core.internal {
	defaulted
}




shared class DefaultedParameterDependency(
 	FunctionalDeclaration&NestableDeclaration|GettableDeclaration&NestableDeclaration  declaration,
 	TypeIdentifier types,
 	Tree tree
 ) extends ParameterDependency(declaration,types, tree){
		
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