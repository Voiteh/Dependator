import herd.depin.api {
	Injection,
	Dependency
}
import ceylon.language.meta.model {
	MemberClassCallableConstructor
}
import herd.depin.engine.dependency {
	Defaulted
}
shared class MemberCallableConstructorInjection(MemberClassCallableConstructor<> constructor,Dependency container,{Dependency*} parameteres) extends Injection(){
	shared actual Object inject {
		value resolvedContainer = container.resolve;
		value resolvedParameters = parameteres.map((Dependency element) => element.resolve).filter((Anything element) => !element is Defaulted);
		return constructor.bind(resolvedContainer).apply(*resolvedParameters);
	}
	
}