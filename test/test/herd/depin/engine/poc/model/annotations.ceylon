import ceylon.language.meta.declaration {
	FunctionOrValueDeclaration
}

shared abstract class Enum() of one |two |three{}
shared object three extends Enum() {}
shared object two extends Enum() {}
shared object one extends Enum() {}

shared annotation final class EnumeratedAnnotation(shared Enum enum) satisfies OptionalAnnotation<EnumeratedAnnotation,FunctionOrValueDeclaration>{}
shared annotation  EnumeratedAnnotation enum(Enum e) =>EnumeratedAnnotation(e);