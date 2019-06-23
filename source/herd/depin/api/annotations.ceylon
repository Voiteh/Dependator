import ceylon.language.meta.declaration {
	FunctionOrValueDeclaration,
	ClassDeclaration,
	CallableConstructorDeclaration,
	ConstructorDeclaration
}

shared abstract class Provision() of singleton | prototype {}
shared object singleton extends Provision() {}
shared object prototype extends Provision() {}

shared final annotation class DependencyAnnotation(
	shared Provision provision)
		satisfies OptionalAnnotation<DependencyAnnotation,FunctionOrValueDeclaration|ClassDeclaration|ConstructorDeclaration> {
}

shared annotation DependencyAnnotation dependency(Provision provision=singleton) => DependencyAnnotation(provision);

shared final annotation class TargetAnnotation() satisfies OptionalAnnotation<TargetAnnotation,CallableConstructorDeclaration>{}
shared annotation TargetAnnotation target() => TargetAnnotation();
shared annotation final class NamedAnnotation(String name) satisfies OptionalAnnotation<NamedAnnotation,FunctionOrValueDeclaration|ConstructorDeclaration>{
	

	shared actual Boolean equals(Object that) {
		if (is NamedAnnotation that) {
			return name==that.name;
		}
		else {
			return false;
		}
	}
	
	shared actual Integer hash => name.hash;
	
	string => name;
}
shared annotation NamedAnnotation named(String name) => NamedAnnotation(name);