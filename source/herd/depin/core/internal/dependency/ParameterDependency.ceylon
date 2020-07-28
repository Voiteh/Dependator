import herd.depin.core {
	log,
	Dependency
}
import ceylon.language.meta.declaration {
	FunctionDeclaration,
	FunctionOrValueDeclaration
}
import herd.depin.core.internal.util {
	safe
}

shared class ParameterDependency(
	String name,
	TypeIdentifier identifier,
	FunctionOrValueDeclaration declaration,
	Tree tree) extends Dependency(name, identifier, declaration) {
	
	shared default Dependency? provide {
		if (exists shadow = tree.get(identifier, name)) {
			return shadow;
		} else if (exists fallback = tree.getFallback(identifier)) {
			return fallback;
		}
		return null;
	}
	
	shared Anything doResolve<Context> (Dependency dependency,Context? context=null) given Context satisfies Object{
		if (is FunctionDeclaration declaration, is FunctionDeclaration dependencyDeclaration = dependency.declaration) {
			return safe(() => dependencyDeclaration.apply<>())((Throwable error) => ResolutionError("Type parameters are not supported for dependencies yet", error));
		} else {
			return dependency.resolve(context);
		}
	}
	
	shared actual default Anything resolve(Anything context) {
		Dependency? dependency = provide;
		Anything resolve;
		if (exists dependency) {
			resolve = doResolve(dependency);
		} else {
			throw Dependency.ResolutionError("Couldn't find dependency ``name`` with type identifier:``identifier`` ", null);
		}
		log.debug("[Resolved parameter dependency]: `` resolve else "null" ``, for type identifier: ``identifier`` and name: ``name``");
		return resolve;
	}
}
