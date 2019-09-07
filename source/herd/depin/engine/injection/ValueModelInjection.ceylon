import ceylon.language.meta.model {

	ValueModel,
	Qualified,
	Gettable
}
import herd.depin.engine {

	Dependency,
	Injection,
	log,
	safe
}
import herd.depin.engine.meta {

	apply
}
shared class ValueModelInjection(ValueModel<> model,Dependency? container) satisfies Injection {
	shared actual Anything inject {
		switch(model)
		case (is Qualified<>) {
			assert(exists container);
			log.debug("[Injecting] into : ``model`` with container: ``container``");
			value resolvedContainer = container.resolve;
			log.trace("Resolved container: ``resolvedContainer else "null"`` for injecting into: ``model`` ");
			return safe(()=>apply(model,resolvedContainer))((Throwable error)=>Exception("Error durring value model injection ``model``, with container ``container``",error));
		}
		else case (is Gettable<>) {
			log.debug("[Injecting] into: ``model`` ");
			return safe(() => apply(model))((Throwable error)=>Exception("Error durring value model injection ``model``"));
		}
		else{
			throw Exception("Unhandeld ValueModelInjection ``model`` with container ``container else "null"``");
		}
	}
	
}