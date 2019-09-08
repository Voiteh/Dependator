
import herd.depin.engine {

	log,
	Dependency
}
shared abstract class Defaulted() of defaulted{}
object defaulted extends Defaulted(){}
shared class DefaultedParameterDependency(Dependency.Definition definition,Dependencies tree) extends ParameterDependency(definition, tree){
	shared actual Anything resolve{
		log.trace("Resolving defaulted parameter dependency: ``definition``");
		Dependency? dependency;
		if (exists shadow= tree.get(definition)) {
			dependency =shadow;
		}else if(exists fallback=tree.getFallback(definition)){
			dependency=fallback;
		}
		else{
			dependency=null;
		}
		if(exists dependency){
			value resolve = dependency.resolve;
			log.trace("Resolved defaulted parameter dependency: ``definition`` to ``resolve else "null"``");
			return resolve;
		}
				
		log.trace("Resolved defaulted parameter dependency: ``definition`` to ``defaulted``");
		return defaulted;
	}
}