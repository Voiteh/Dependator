import herd.depin.core {
	log,
	Dependency
}
import herd.depin.core.internal.util {
	invoke,
	safe
}
import ceylon.language.meta.declaration {
	GettableDeclaration,
	NestableDeclaration
}

shared class GettableDependency(
	GettableDeclaration&NestableDeclaration declaration,
	TypeIdentifier identifier,
	Dependency? container
) extends Dependency(declaration,identifier, container, empty) {
	
	shared actual Anything resolve {
		if (exists container, exists resolved = container.resolve) {
			value result = safe(() => invoke(declaration, resolved))((Throwable error) => 
				ResolutionError("Resolution failed for ``identifier`` with container ``container``",error));
			log.debug("[Resolved] value member dependency `` result else "null" `` for definition ``identifier`` and container ``container``");
			return result;
		}
		value result = safe(() => invoke(declaration))((Throwable error) => 
			ResolutionError("Resolution failed for definition ``identifier``",error));
		log.debug("[Resolved] value dependency: `` result else "null" ``, for definition: ``identifier``");
		return result;
	}
}
