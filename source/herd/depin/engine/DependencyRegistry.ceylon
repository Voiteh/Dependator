import ceylon.collection {
	MutableMap,
	HashMap
}
import ceylon.language.meta.declaration {
	OpenType
}

import herd.depin.api {
	Dependency,
	Definition
}
shared class DependencyRegistry(MutableMap<OpenType,Register> registries= HashMap<OpenType,Register>()) satisfies Dependency.Registry{
	shared actual Dependency? add(Dependency dependency) {
		value get = registries.get(dependency.definition.type);
		if (exists get) {
			return get.add(dependency.definition,dependency);
		}
		value register=Register();
		registries.put(dependency.definition.type,register);
		return register.add(dependency.definition, dependency);
		
	}
	
	
	
	shared actual Dependency? get(Definition description) {
		if (exists get = registries.get(description.type)) {
			return get.get(description);
		}
		value newRegister=Register();
		registries.put(description.type,newRegister);
		return null;
	}
	string => registries.fold("")((String initial, OpenType type -> Register register) => initial + "``type``: ``register``\n\r" );
}