import herd.depin.api {
	Dependency
}
shared abstract class Defaulted() of defaulted{}
object defaulted extends Defaulted(){}
shared class DefaultedParameterDependency(Dependency.Definition definition,Dependencies tree) extends ParameterDependency(definition, tree){
	shared actual Anything resolve{
		if(exists dependency =tree.get(definition)){
			return dependency.resolve;
		}
		return defaulted;
	}
}