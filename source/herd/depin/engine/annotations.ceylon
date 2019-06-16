import ceylon.language.meta.declaration {
	FunctionOrValueDeclaration,
	ClassDeclaration,
	CallableConstructorDeclaration
}

shared abstract class Provision() of singleton | prototype {}
shared object singleton extends Provision() {}
shared object prototype extends Provision() {}

shared final annotation class DependencyAnnotation(
	shared Provision provision)
		satisfies OptionalAnnotation<DependencyAnnotation,FunctionOrValueDeclaration> {
}

shared annotation DependencyAnnotation dependency(Provision provision=singleton) => DependencyAnnotation(provision);

shared final annotation class TargetAnnotation() satisfies OptionalAnnotation<TargetAnnotation,ClassDeclaration|CallableConstructorDeclaration>{}
shared TargetAnnotation target() => TargetAnnotation();