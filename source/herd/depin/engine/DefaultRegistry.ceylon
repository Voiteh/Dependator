import herd.depin.api {
	Registry,
	Injectable,
	Dependency,
	Register
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
shared class DefaultRegistry(MutableMap<OpenType,Register> registries= HashMap<OpenType,Register>(),shared actual Type<Annotation>[] controls=[]) satisfies Registry{
	shared actual Injectable? add(Dependency description, Injectable injectable) {
		value get = registries.get(description.type);
		if (exists get) {
			return get.add(description,injectable);
		}
		value register=DefaultRegister();
		registries.put(description.type,register);
		return register.add(description, injectable);
		
	}
	
	
	
	shared actual Injectable? get(Dependency description) {
		if (exists get = registries.get(description.type)) {
			return get.get(description);
		}
		value newRegister=DefaultRegister();
		registries.put(description.type,newRegister);
		return null;
	}
	
}