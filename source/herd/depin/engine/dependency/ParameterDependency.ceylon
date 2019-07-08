import herd.depin.api {
	Dependency
}
shared class ParameterDependency(Dependency.Definition definition,Dependencies tree) extends Dependency(definition){
	shared actual default Anything resolve => tree.get(definition)?.resolve;
	
}