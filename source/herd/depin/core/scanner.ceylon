import ceylon.language.meta.declaration {
	Declaration,
	FunctionOrValueDeclaration,
	ClassDeclaration,
	Module,
	Package,
	ValueDeclaration
}
import ceylon.language.meta.model {

	Class,
	Attribute,
	Value
}
import ceylon.language.meta {

	type
}

"Scans given scopes and produces declarations to be transformed into [[Dependency]]ies"
shared object scanner {
	{FunctionOrValueDeclaration*} single(Scope scope) {
		log.trace("Scanning scope ``scope``");
		switch (scope)
		case (is ClassDeclaration) {
			{FunctionOrValueDeclaration*} members = scope.declaredMemberDeclarations<ClassDeclaration|FunctionOrValueDeclaration>()
					.flatMap((Scope element) => single(element));
			return members;
		}
		case (is FunctionOrValueDeclaration) {
			if (scope.annotated<DependencyAnnotation>()) {
				log.debug("Included ``scope``");
				return { scope }; 
			} else {
				return empty;
			}
		}
		case (is Package) {
			return scope.members<ClassDeclaration|FunctionOrValueDeclaration>()
					.flatMap((Scope element) => single(element));
		}
		case (is Module) {
			return scope.members.flatMap((Package element) => single(element));
		}
	}
	"Scans included [[inclusions]], reduced by excluded [[exclusions]] producing sequence of declarations for transformations into [[Dependency]]. 
	 Only declarations annotated with [[dependency]] and they container classes are taken in consideration"
	shared FunctionOrValueDeclaration[] dependencies({Scope*} inclusions, {Scope*} exclusions=[]) {
		[FunctionOrValueDeclaration+]|[] excluded = exclusions.flatMap((Scope element) => single(element)).sequence();
		return inclusions.flatMap((Scope element) => single(element))
				.filter((Declaration element) => !excluded.contains(element)).sequence();
	}
	
	
	shared Value<>[] compleatables(Object target){
		return type(target).getAttributes<>(`CompleatableAnnotation`)
				.map((Attribute<> element) => element.bind(target))
				.sequence();
	}
	
	
}