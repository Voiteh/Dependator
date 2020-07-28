import ceylon.language.meta.model {

	ValueModel,
	Qualified,
	Gettable
}


import herd.depin.core.internal.util {
	safe,
	apply
}

import herd.depin.core {

	log,
	Dependency,
	Injection
}
shared class ValueModelInjection(ValueModel<> model,Dependency? container) extends Injection(model,container) {
	shared actual Anything inject(Anything context) {
		switch(model)
		case (is Qualified<>) {
			assert(exists container);
			log.debug("[Injecting] into : ``model`` with container: ``container``");
			value resolvedContainer = safe(()=> container.resolve(context))
			((Throwable cause) => Error(cause,model,container));
			log.trace("Resolved container: ``resolvedContainer else "null"`` for injecting into: ``model`` ");
			return safe(()=>apply(model,resolvedContainer))
			((Throwable error)=>Error(error,model,resolvedContainer));
		}
		else case (is Gettable<>) {
			log.debug("[Injecting] into: ``model``");
			return safe(() => apply(model))
			((Throwable error)=>Error(error,model));
		}
		else{
			throw Error(Exception("Unhandeld ValueModelInjection"),model,container);
		}
	}
	
}