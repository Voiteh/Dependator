import ceylon.language.meta.declaration {
	FunctionOrValueDeclaration,
	ClassDeclaration,
	CallableConstructorDeclaration
}

shared abstract class Provision() of singleton | prototype {}
shared object singleton extends Provision() {}
shared object prototype extends Provision() {}

shared final annotation class DependencyAnnotation(
	Provision provision,
	{ClassDeclaration*} annotations)
		satisfies OptionalAnnotation<DependencyAnnotation,FunctionOrValueDeclaration> {
}

shared DependencyAnnotation dependency(Provision provision=singleton,{ClassDeclaration*} annotations=empty) => DependencyAnnotation(provision, annotations);

shared final annotation class TargetAnnotation() satisfies OptionalAnnotation<TargetAnnotation,ClassDeclaration|CallableConstructorDeclaration>{}
shared TargetAnnotation target() => TargetAnnotation();