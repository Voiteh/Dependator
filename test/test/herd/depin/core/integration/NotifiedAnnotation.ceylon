import ceylon.language.meta.declaration {
	ValueDeclaration
}


import ceylon.language.meta.model {
	Value
}
import herd.depin.core {

	Dependency,
	Handler
}
shared final annotation class NotifiedAnnotation() 
		satisfies Dependency.Decorator & OptionalAnnotation<NotifiedAnnotation, ValueDeclaration, Value<Boolean>>  {
	shared actual Dependency.Decoration decorate(Dependency dependency) => object extends Dependency.Decoration(dependency,outer) satisfies Handler<Boolean>{

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