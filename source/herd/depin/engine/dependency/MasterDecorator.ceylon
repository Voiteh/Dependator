import herd.depin.api {
	Dependency
}
import ceylon.language.meta.declaration {
	FunctionOrValueDeclaration
}
shared class MasterDecorator() {
	shared Dependency decorate(FunctionOrValueDeclaration declaration,Dependency dependency) {
		return declaration.annotations<Annotation>()
				.narrow<Dependency.Decorator>()
				.fold(dependency)((Dependency dependency, Annotation&Dependency.Decorator decorator) => decorator.decorate(dependency));
				
	}
	
}