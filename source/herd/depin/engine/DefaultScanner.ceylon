import ceylon.language.meta.declaration {
	Declaration,
	FunctionOrValueDeclaration,
	Package,
	Module,
	ClassDeclaration
}

import herd.depin.engine {
	Scanner,
	DependencyAnnotation
}
import ceylon.logging {
	logger
}

shared class DefaultScanner() extends Scanner() {
	value log=logger(`module`);
	{FunctionOrValueDeclaration*} single(Scope scope) {
		log.trace("Scanning scope ``scope``");
		switch (scope)
		case (is ClassDeclaration) {
			{FunctionOrValueDeclaration*} members = scope.memberDeclarations<ClassDeclaration|FunctionOrValueDeclaration>()
				.flatMap((Scope element) => single(element));
			return members;
		}
		case (is FunctionOrValueDeclaration) {
			return if (scope.annotated<DependencyAnnotation>()) then { scope } else empty;
		}
		case (is Package) {
			return scope.members<ClassDeclaration|FunctionOrValueDeclaration>()
				.flatMap((Scope element) => single(element));
		}
		case (is Module) {
			return scope.members.flatMap((Package element) => single(element));
		}
	}
	
	shared actual {FunctionOrValueDeclaration*} scan({Scope*} inclusions, {Scope*} exclusions) {
		[FunctionOrValueDeclaration+]|[] excluded = exclusions.flatMap((Scope element) => single(element)).sequence();
		return inclusions.flatMap((Scope element) => single(element))
			.filter((Declaration element) => !excluded.contains(element));
	}
}