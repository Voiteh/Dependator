import herd.depin.api {
	Dependency
}
import herd.depin.engine {

	log
}
shared class ParameterDependency(Dependency.Definition definition,Dependencies tree) extends Dependency(definition){
	shared actual default Anything resolve {
		 value resolve = tree.get(definition)?.resolve;
		 log.debug("[Resolved] parameter dependency: ``resolve else "null"``, for definition: ``definition``");
		 return resolve;
	}
	
}