import ceylon.language.meta.model {
	Function,
	FunctionModel,
	CallableConstructor,
	Method,
	MemberClassCallableConstructor
}

import herd.depin.engine {
	log,
	Dependency,
	Injection
}
import herd.depin.engine.internal.util {
	apply,
	safe
}
class FunctionModelInjection(FunctionModel<> model,Dependency? container,{Dependency*} parameters) extends Injection(model,container,parameters){
	shared actual Anything inject {
		log.debug("[Injecting] into: ``model``, parameters: ``parameters`` for container `` container else "null" ``");
		value resolvedContainer= if(exists container ) then safe(()=>container.resolve )
		((Throwable cause) => Error(cause,model,container,parameters))
		else null;
		log.trace("[Resolved] container: ``resolvedContainer else "null"`` for injecting into: ``model`` ");
		value resolvedParameters = safe(()=>parameters.map((Dependency element) => element.resolve).select((Anything element) => !element is Defaulted))
		((Throwable cause)=>Error(cause,model,container,parameters));
		log.trace("[Resolved] parameters: ``resolvedParameters`` for injecting into:``model`` ");	
		switch(model)
		case (is Function<>| CallableConstructor<>|Method<>|MemberClassCallableConstructor<>) {
			return safe(()=>apply(model,resolvedContainer,resolvedParameters))((Throwable error)=>Error(error,model,resolvedContainer,resolvedParameters));
		}
		else{
			throw Error(Exception("Unhandled model type ``model`` for container ``container else "null"``, parameters: ``parameters``"),model,resolvedContainer,resolvedParameters);
		}
		
	}
	
}