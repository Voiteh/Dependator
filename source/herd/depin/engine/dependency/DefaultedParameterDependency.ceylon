import herd.depin.api {
	Dependency
}
shared abstract class Defaulted() of defaulted{}
object defaulted extends Defaulted(){}
shared class DefaultedParameterDependency(Dependency.Definition definition,Dependencies tree) extends ParameterDependency(definition, tree){
	shared actual Anything resolve{
		log.trace("Resolving defaulted parameter dependency: ``definition``");
		if(exists dependency =tree.get(definition)){
			value resolve = dependency.resolve;
			log.trace("Resolved defaulted parameter dependency: ``definition`` to ``resolve else "null"``");
		}
		log.trace("Resolved defaulted parameter dependency: ``definition`` to ``defaulted``");
		return defaulted;
	}
}