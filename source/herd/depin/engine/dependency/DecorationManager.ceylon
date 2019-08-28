import ceylon.language.meta {
	type
}
import ceylon.language.meta.model {
	Type,
	Interface,
	UnionType
}

import herd.depin.api {
	Dependency,
	Handler
}
import herd.type.support {
	flat
}
import herd.depin.engine {

	log
}
import ceylon.language.meta.declaration {

	AnnotatedDeclaration
}

shared class DecorationManager(Handlers handlers) {
	{Dependency.Decorator*} decorators(AnnotatedDeclaration declaration){
		return declaration.annotations<Annotation>()
				.narrow<Dependency.Decorator>();
	}

	shared Dependency|Dependency.Decorated decorate(Dependency dependency) {
		log.trace("decorating ``dependency``");
		
		Dependency|Dependency.Decorated decorated = decorators(dependency.definition.declaration).fold(dependency)((Dependency subject, Dependency.Decorator decorator) {
			Dependency.Decorated result=decorator.decorate(subject);
			log.debug("[Decorated]: ``dependency``, with ``result``");
			if(is Handler<> result){
				register(result);
			}
			return result;
		});
		
		return decorated;
	}
	
	void register(Handler<> handler) {
		flat.types(type(handler))
				.rest
				.filter((Type<Anything> element) => element.subtypeOf(`Handler<>`))
				.each((Type<Anything> element) {
			assert (is Interface<Handler<>> element);
			assert (exists eventType = element.typeArgumentList.first);
			if(is UnionType<> eventType){
				eventType.caseTypes.each((Type<Anything> element) => handlers.add(element, handler));
			}
			else{
				handlers.add(eventType,handler);
			}
			log.debug("Registered handler ``element`` for ``eventType``");
		});
	}
}