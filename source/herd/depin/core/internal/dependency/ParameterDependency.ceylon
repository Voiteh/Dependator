import herd.depin.core {
	log,
	Dependency
}
import ceylon.language.meta.declaration {
	FunctionDeclaration,
	FunctionalDeclaration,
	GettableDeclaration,
	NestableDeclaration
}
import herd.depin.core.internal.util {
	safe
}


shared class ParameterDependency(
	<FunctionalDeclaration&NestableDeclaration|GettableDeclaration&NestableDeclaration> declaration,
	TypeIdentifier identifier,
	Tree tree
)
		extends Dependency(declaration, identifier) {
	shared default Dependency? provide {
		if (exists shadow = tree.get(identifier,name)) {
			return shadow;
		} else if (exists fallback = tree.getFallback(identifier)) {
			return fallback;
		}
		return null;
	}
	
	shared Anything doResolve(Dependency dependency) {
		if (is FunctionDeclaration declaration, is FunctionDeclaration dependencyDeclaration = dependency.declaration) {
			return safe(() => dependencyDeclaration.apply<>())((Throwable error) => ResolutionError("Type parameters are not supported for dependencies yet", error));
		} else {
			return dependency.resolve;
		}
	}
	
	shared actual default Anything resolve {
		Dependency? dependency = provide;
		Anything resolve;
		if (exists dependency) {
			resolve = doResolve(dependency);
		} else {
			throw Dependency.ResolutionError("Couldn't find dependency for definition ``identifier``", null);
		}
		log.debug("[Resolved] parameter dependency: `` resolve else "null" ``, for definition: ``identifier``");
		return resolve;
	}
}
