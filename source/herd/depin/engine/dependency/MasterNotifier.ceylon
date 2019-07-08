import herd.depin.api {
	Notifier,
	Handler
}
import ceylon.language.meta {
	type
}
import herd.type.support {
	flat
}
import ceylon.language.meta.model {
	Type
}
shared class MasterNotifier(Handlers handlers) satisfies Notifier{
	shared actual void notify<Event>(Event event) {
		value types = flat.types( type(event));
		types.flatMap((Type<Anything> element) => handlers.get(element))
			.narrow<Handler<Event>>()
			.each((Handler<Event> element) => element.onEvent(event));
		
	}

}