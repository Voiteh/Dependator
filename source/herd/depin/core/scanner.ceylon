import ceylon.language.meta.declaration {
	Declaration,
	FunctionOrValueDeclaration,
	ClassDeclaration,
	Module,
	Package,
	ClassOrInterfaceDeclaration
}
import herd.type.support {
	flat
}


"Scans given scopes and produces declarations to be transformed into [[Dependency]]ies"
shared object scanner {
	
	{FunctionOrValueDeclaration*} singleScopeFunctionOrValue(Scope scope) {
		log.trace("Scanning scope ``scope``");
		switch (scope)
		case (is ClassDeclaration) {
			{FunctionOrValueDeclaration*} members = scope.declaredMemberDeclarations<ClassDeclaration|FunctionOrValueDeclaration>()
				.chain(scope.memberDeclarations<ClassDeclaration|FunctionOrValueDeclaration>())
				.flatMap((Scope element) => singleScopeFunctionOrValue(element));
			return members;
		}
		case (is FunctionOrValueDeclaration) {
			if (scope.annotated<DependencyAnnotation>()) {
				log.debug("[Included scope] ``scope``");
				return { scope };
			} else {
				return empty;
			}
		}
		case (is Package) {
			return scope.members<ClassDeclaration|FunctionOrValueDeclaration>()
				.flatMap((Scope element) => singleScopeFunctionOrValue(element));
		}
		case (is Module) {
			return scope.members.flatMap((Package element) => singleScopeFunctionOrValue(element));
		}
	}
	
	{ClassDeclaration*} singleScopeConcreteClass(Scope scope) {
		log.trace("Scanning scope ``scope``");
		switch (scope)
		case (is ClassDeclaration) {
			{ClassDeclaration*} members =
				scope.declaredMemberDeclarations<ClassDeclaration>()
					.chain(scope.memberDeclarations<ClassDeclaration>())
					.flatMap((Scope element) => singleScopeConcreteClass(element))
					.follow(scope)
					.filter((ClassDeclaration declaration) => !declaration.abstract)
					.filter((ClassDeclaration declaration) => declaration.typeParameterDeclarations.empty);
			return members;
		}
		case (is Package) {
			return scope.members<ClassDeclaration>()
				.flatMap((Scope element) => singleScopeConcreteClass(element));
		}
		case (is Module) {
			return scope.members.flatMap((Package element) => singleScopeConcreteClass(element));
		}
		else {
			return empty;
		}
	}
	
	
	"Scans included [[inclusions]], reduced by excluded [[exclusions]] producing sequence of declarations for transformations into [[Dependency]]. 
	             Only declarations annotated with [[dependency]] and they container classes are taken in consideration"
	shared FunctionOrValueDeclaration[] dependencies({Scope*} inclusions, {Scope*} exclusions = []) {
		FunctionOrValueDeclaration[] excluded = exclusions.flatMap((Scope element) => singleScopeFunctionOrValue(element)).sequence();
		return inclusions.flatMap((Scope element) => singleScopeFunctionOrValue(element))
			.filter((Declaration element) {
				if (excluded.contains(element)) {
					log.trace("Excluded element ``element``");
					return false;
				}
				log.trace("Included element ``element``");
				return true;
			})
			.distinct
			.sequence();
	}
	"Scans included [[inclusions]], reduced by excluded [[exclusions]]  to be transformed into [[Dependency]]. 
	       Only subtype of given [[declaration]] concrete classes and their member concrete classes are taken in consideration,
	       class musn't have any type parameters to be used by [[Depin]] 
	       [[dependency]] annotation is ignored in this case. "
	shared ClassDeclaration[] subtypeDependencies(ClassOrInterfaceDeclaration declaration, {Scope*} inclusions, {Scope*} exclusions = []) {
		ClassDeclaration[] excluded = exclusions.flatMap((Scope element) => singleScopeConcreteClass(element)).sequence();
		return inclusions.flatMap((Scope element) => singleScopeConcreteClass(element))
			.filter((ClassDeclaration element) {
				value flatDeclarations = flat.declarations(element);
				if (excluded.contains(element) || !flatDeclarations.contains(declaration)) {
					log.trace("Excluded element ``element``");
					return false;
				}
				log.trace("Included element ``element``");
				return true;
			})
			.distinct
			.sequence();
	}
}
