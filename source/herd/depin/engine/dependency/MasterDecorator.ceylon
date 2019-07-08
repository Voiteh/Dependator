import herd.depin.api {
	Dependency,
	Handler
}
import ceylon.language.meta.declaration {
	FunctionOrValueDeclaration
}
import ceylon.language.meta {
	type
}
import herd.type.support {
	flat
}
import ceylon.language.meta.model {
	Type,
	Interface,
	UnionType
}

shared class MasterDecorator(Handlers handlers) satisfies Dependency.Decorator {
	shared actual Dependency decorate(Dependency dependency) {
		return dependency.decorators.fold(dependency)((Dependency subject, Dependency.Decorator decorator) {
			value result=decorator.decorate(subject);
			if(is Handler<> result){
				register(result);
			}
			return result;
		});
	}
	
	void register(Handler<> handler) {
		flat.types(type(handler))
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
			});
	}
}