import ceylon.language.meta.model {
	Function,
	FunctionModel,
	CallableConstructor,
	Method,
	MemberClassCallableConstructor
}


import herd.depin.engine.dependency {
	Defaulted
}
import herd.depin.engine {

	log,
	Dependency,
	Injection,
	safe
}

import herd.depin.engine.meta {
	apply
}
shared class FunctionModelInjection(FunctionModel<> model,Dependency? container,{Dependency*} parameters) satisfies Injection{
	shared actual Anything inject {
		log.debug("[Injecting] into: ``model``, parameters: ``parameters`` for container `` container else "null" ``");
		value resolvedContainer= if(exists container ) then container.resolve else null;
		log.trace("[Resolved] container: ``resolvedContainer else "null"`` for injecting into: ``model`` ");
		value resolvedParameters = parameters.map((Dependency element) => element.resolve).select((Anything element) => !element is Defaulted);
		log.trace("[Resolved] parameters: ``resolvedParameters`` for injecting into:``model`` ");	
		switch(model)
		case (is Function<>| CallableConstructor<>|Method<>|MemberClassCallableConstructor<>) {
			return safe(()=>apply(model,resolvedContainer,resolvedParameters))((Throwable error)=>Exception ("Injection falied for model``model``, container ``resolvedContainer else "null"``, parameters ``resolvedParameters``"));
		}
		else{
			throw Exception("Unhandled model type ``model`` for container ``container else "null"``, parameters: ``parameters``");
		}
		
	}
	
}