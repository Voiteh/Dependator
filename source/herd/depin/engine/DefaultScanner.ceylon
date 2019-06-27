import herd.depin.api {
	Scope,
	Scanner,
	DependencyAnnotation
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
		switch (element)
		case (is ClassDeclaration) {
			if(exists anonymousObject=element.objectValue,exists anonymousClass = anonymousObject.objectClass){
				value members = element.memberDeclarations<ClassDeclaration|FunctionOrValueDeclaration>()
						.flatMap((Scope element) => single(element));
				return if(!members.empty) then members.follow(anonymousObject) else empty;
			}
			else if(element.annotated<DependencyAnnotation>()|| !element.constructorDeclarations().filter((ConstructorDeclaration element) => element.annotated<DependencyAnnotation>()).empty){
				return element.memberDeclarations<ClassDeclaration|FunctionOrValueDeclaration>()
						.flatMap((Scope element) => single(element)).follow(element);
			}else{
				value members = element.memberDeclarations<ClassDeclaration|FunctionOrValueDeclaration>()
						.flatMap((Scope element) => single(element));
				return if(!members.empty) then members.follow(element) else empty;
			}
				
		}
		case (is FunctionOrValueDeclaration) {
			return if (element.annotated<DependencyAnnotation>()) then { element } else empty;
		}
		case (is Package) {
			return element.members<ClassDeclaration|FunctionOrValueDeclaration>()
				.flatMap((Scope element) => single(element));
		}
		case (is Module) {
			return element.members.flatMap((Package element) => single(element));
		}
	}
	
	shared actual {Declaration*} scan({Scope*} inclusions, {Scope*} exclusions) {
		value excluded = exclusions.flatMap((Scope element) => single(element)).sequence();
		return inclusions.flatMap((Scope element) => single(element))
			.filter((Declaration element) => !excluded.contains(element));
	}
}
