import herd.depin.api {
	Scope,
	Scanner,
	Registry
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
		
	 {Declaration*} single(Scope element) {
		switch(element)
		case (is ClassDeclaration) {
			return element.constructorDeclarations()
					.filter((ConstructorDeclaration element) => !element.annotations<TargetAnnotation>().empty)
					.chain(element.memberDeclarations<FunctionOrValueDeclaration>().flatMap((FunctionOrValueDeclaration element) => single(element)));	
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
					.flatMap((ClassDeclaration|FunctionOrValueDeclaration element) => single(element));
		}
		case (is Module){
			return element.members.flatMap((Package element) => single(element));
		}
	}

	
	shared actual {Declaration*} scan({Scope*} inclusions, {Scope*} exclusions) {
		value excluded = exclusions.flatMap((Scope element) => single(element)).sequence();
		return inclusions.flatMap((Scope element) => single(element))
			.filter((Declaration element) => !excluded.contains(element));
	}
	
	
		
}