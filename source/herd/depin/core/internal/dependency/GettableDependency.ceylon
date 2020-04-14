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
	String name,
	TypeIdentifier identifier,
	GettableDeclaration&NestableDeclaration declaration,
	Dependency? container
) extends ContainableDependency(name,identifier,declaration,container) {
	
	shared actual Anything resolve {
		if (exists container, exists resolved = container.resolve) {
			value result = safe(() => invoke(declaration, resolved))((Throwable error) => 
				ResolutionError("Resolution failed for ``identifier`` with container ``container``",error));
			log.debug("[Resolved value member dependency] `` result else "null" `` for type identifier ``identifier``, name:``name`` and container ``container``");
			return result;
		}
		value result = safe(() => invoke(declaration))((Throwable error) => 
			ResolutionError("Resolution failed for definition ``identifier``",error));
		log.debug("[Resolved value dependency]: `` result else "null" ``, for type identifier: ``identifier`` and name: ``name`` ");
		return result;
	}
}
