import herd.depin.api {
	Scope,
	Scanner
}
import ceylon.language.meta.declaration {
	Declaration,
	FunctionOrValueDeclaration,
	Package,
	Module,
	ClassDeclaration,
	ConstructorDeclaration
}

shared class DefaultScanner() extends Scanner() {
	
	shared actual {Declaration*} scan(Scope element) {
		switch(element)
		case (is ClassDeclaration) {
			return element.constructorDeclarations()
					.filter((ConstructorDeclaration element) => !element.annotations<TargetAnnotation>().empty)
					.chain(element.memberDeclarations<FunctionOrValueDeclaration>().flatMap((FunctionOrValueDeclaration element) => scan(element)));	
		}
		case (is FunctionOrValueDeclaration){
			value annotations = element.annotations<DependencyAnnotation>();
			if(!annotations.empty){
				return {element};
			}
			return empty;
		}
		case (is Package){
			return element.members<ClassDeclaration|FunctionOrValueDeclaration>()
					.flatMap((ClassDeclaration|FunctionOrValueDeclaration element) => scan(element));
		}
		case (is Module){
			return element.members.flatMap((Package element) => scan(element));
		}
	}

	
		
}