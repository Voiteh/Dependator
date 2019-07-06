import herd.depin.api {
	Dependency
}
import ceylon.language.meta.declaration {
	FunctionalDeclaration
}
shared class FunctionalDependency(FunctionalDeclaration declaration,
	Dependency.Definition definition,
	Dependency? container,
	{Dependency*} parameters
) extends Dependency(definition,container,parameters){
	shared actual Anything resolve{
		value resolvedParameters = parameters.map((Dependency element) => element.resolve).filter((Anything element) =>!element is Defaulted);
		if(exists resolved=container?.resolve){
			return declaration.memberInvoke(resolved,[], *resolvedParameters);
		}
		return declaration.invoke([],*resolvedParameters);
	}
	
	
}