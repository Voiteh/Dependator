import ceylon.language.meta {
	type
}
import ceylon.language.meta.model {
	Type
}

import herd.depin.engine {
	log,
	Handler
}
import herd.type.support {
	flat
}



shared class NotificationManager(Handlers handlers)  {
	shared  void notify<Event>(Event event) {
		value types = flat.types(type(event));
		types.flatMap((Type<Anything> element) => handlers.get(element))
			.narrow<Handler<Event>>()
			.each((Handler<Event> element) {
				log.debug("Notifng ``element`` for `` event else "null" ``");
				element.onEvent(event);
			});
	}
}
