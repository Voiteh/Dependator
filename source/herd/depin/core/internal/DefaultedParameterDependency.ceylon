
import herd.depin.core {
	log,
	Dependency
}
import ceylon.language.meta.declaration {
	FunctionalDeclaration,
	NestableDeclaration,
	GettableDeclaration
}


abstract class Defaulted() of defaulted{}
object defaulted extends Defaulted(){}
 class DefaultedParameterDependency(
 	FunctionalDeclaration&NestableDeclaration|GettableDeclaration&NestableDeclaration  declaration,
 	Dependency.Definition definition,
 	Dependencies tree
 ) extends ParameterDependency(declaration,definition, tree){
		
	shared actual Anything resolve{
		log.trace("Resolving defaulted parameter dependency: ``definition``");
		Dependency? dependency=provide;
		if(exists dependency){
			Anything resolve=doResolve(dependency);
			log.debug("[Resolved] defaulted parameter dependency: `` resolve else "null" ``, for definition: ``definition``");
			return resolve;
		}
		log.trace("[Resolved] defaulted parameter dependency: ``definition`` to ``defaulted``");
		return defaulted;
	}
}