import herd.depin.core {
	log,
	Dependency
}
import herd.depin.core.internal.util {
	invoke,
	safe
}

class ValueDependency(
	Dependency.Definition definition,
	Dependency? container) extends Dependency(definition, container, empty) {
	
	shared actual Anything resolve {
		if (exists container, exists resolved = container.resolve) {
			value result = safe(() => invoke(definition.declaration, resolved))((Throwable error) => 
				ResolutionError("Resolution failed for ``definition`` with container ``container``",error));
			log.debug("[Resolved] value member dependency `` result else "null" `` for definition ``definition`` and container ``container``");
			return result;
		}
		value result = safe(() => invoke(definition.declaration))((Throwable error) => 
			ResolutionError("Resolution failed for definition ``definition``",error));
		log.debug("[Resolved] value dependency: `` result else "null" ``, for definition: ``definition``");
		return result;
	}
}
