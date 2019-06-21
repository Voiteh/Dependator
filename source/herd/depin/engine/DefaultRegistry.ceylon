import herd.depin.api {
	Registry,
	Injectable,
	Dependency
}
import ceylon.collection {
	MutableMap,
	HashMap
}

import ceylon.language.meta.declaration {
	OpenType
}
import ceylon.language.meta.model {
	Type
}
shared class DefaultRegistry(shared actual Type<Annotation>[] controls=[`NamedAnnotation`],MutableMap<OpenType,Register> registries= HashMap<OpenType,Register>()) satisfies Registry{
	shared actual Injectable? add(Dependency description, Injectable injectable) {
		value get = registries.get(description.type);
		if (exists get) {
			return get.add(description,injectable);
		}
		value register=Register();
		registries.put(description.type,register);
		return register.add(description, injectable);
		
	}
	
	
	
	shared actual Injectable? get(Dependency description) {
		if (exists get = registries.get(description.type)) {
			return get.get(description);
		}
		value newRegister=Register();
		registries.put(description.type,newRegister);
		return null;
	}
	string => registries.fold("")((String initial, OpenType type -> Register register) => initial + "``type``: ``register``\n\r" );
}