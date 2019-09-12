
import herd.depin.core {
	log,
	Dependency
}


class ParameterDependency(Dependency.Definition definition, Dependencies tree) extends Dependency(definition) {
	shared actual default Anything resolve {
		Dependency? dependency;
		if (exists shadow= tree.get(definition)) {
			dependency =shadow;
		}else if(exists fallback=tree.getFallback(definition)){
			dependency=fallback;
		}
		else{
			dependency=null;
		}
		value resolve = dependency?.resolve;
		log.debug("[Resolved] parameter dependency: `` resolve else "null" ``, for definition: ``definition``");
		return resolve;
	}
}