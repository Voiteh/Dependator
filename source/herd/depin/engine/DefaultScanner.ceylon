import ceylon.language.meta.declaration {
	Declaration,
	FunctionOrValueDeclaration,
	Package,
	Module,
	ClassDeclaration
}

import herd.depin.api {
	Scope,
	Scanner,
	DependencyAnnotation
}

shared class DefaultScanner() extends Scanner() {
	
	{FunctionOrValueDeclaration*} single(Scope element) {
		switch (element)
		case (is ClassDeclaration) {
			
			{FunctionOrValueDeclaration*} members = element.memberDeclarations<ClassDeclaration|FunctionOrValueDeclaration>()
				.flatMap((Scope element) => single(element));
			return members;
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
	
	shared actual {FunctionOrValueDeclaration*} scan({Scope*} inclusions, {Scope*} exclusions) {
		[FunctionOrValueDeclaration+]|[] excluded = exclusions.flatMap((Scope element) => single(element)).sequence();
		return inclusions.flatMap((Scope element) => single(element))
			.filter((Declaration element) => !excluded.contains(element));
	}
}