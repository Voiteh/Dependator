import ceylon.language.meta.declaration {
	ValueDeclaration
}

import herd.depin.api {
	Dependency,
	Handler
}
import ceylon.language.meta.model {
	Value
}
shared final annotation class NotifiedAnnotation() satisfies OptionalAnnotation<NotifiedAnnotation, ValueDeclaration, Value<Boolean>> 
		& Dependency.Decorator{
	shared actual Dependency.Decorated decorate(Dependency dependency) => object extends Dependency.Decorated(dependency,outer) satisfies Handler<Boolean>{
		late Boolean notified;
		shared actual Anything resolve { 
			try{ 
				return notified;
			} catch(InitializationError x){
				return dependency.resolve;
			}
	
		}
		shared actual void onEvent(Boolean event) {
			notified=event;
		}
		
		
	};
	
	
}

shared annotation NotifiedAnnotation notified() => NotifiedAnnotation();