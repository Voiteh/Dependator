import ceylon.collection {
	HashMap,
	MutableMap
}

import herd.depin.api {
	Definition,
	Dependency
}

shared class Register(MutableMap<Definition,Dependency> map=HashMap<Definition, Dependency>()) {
	shared  Dependency? add(Definition description, Dependency injectable) {
		return map.put(description,injectable);
	}
	

	
	shared  Dependency? get(Definition description) => map.get(description);

	string=> map.fold("")((String initial, Definition dependency -> Dependency injectable) => initial + ",``dependency.identification``" )	;
}
