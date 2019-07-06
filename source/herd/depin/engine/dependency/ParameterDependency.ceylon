import herd.depin.api {
	Dependency
}
shared class ParameterDependency(Dependency.Definition definition,Dependency.Tree tree) extends Dependency(definition){
	shared actual default Anything resolve => tree.get(definition)?.resolve;
	
}