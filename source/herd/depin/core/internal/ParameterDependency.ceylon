
import herd.depin.core {
	log,
	Dependency
}
import ceylon.language.meta.declaration {

	FunctionDeclaration
}
import herd.depin.core.internal.util {

	safe
}



class ParameterDependency(Dependency.Definition definition, Dependencies tree) extends Dependency(definition) {
	shared default Dependency? provide {
		if (exists shadow= tree.get(definition)) {
			return shadow;
		}else if(exists fallback=tree.getFallback(definition)){
			return fallback;
		}
		return null;
	}
	
	shared Anything doResolve(Dependency dependency){
		if(is FunctionDeclaration declaration =definition.declaration) {
			return safe(()=> declaration.apply<>())((Throwable error)=>ResolutionError("Type parameters are not supported for dependencies yet", error));
		}
		else{
			return dependency.resolve;
		}
	}
	
	shared actual default Anything resolve {
		Dependency? dependency=provide;
		Anything resolve;
		 if(exists dependency){
			resolve=doResolve(dependency) ;
		}else{
			throw Dependency.ResolutionError("Couldn't find dependency for definition ``definition``",null);
		}
		log.debug("[Resolved] parameter dependency: `` resolve else "null" ``, for definition: ``definition``");
		return resolve;
	}
}