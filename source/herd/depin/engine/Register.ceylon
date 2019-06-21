import ceylon.collection {
	HashMap,
	MutableMap
}

import herd.depin.api {
	Dependency,
	Injectable
}

shared class Register(MutableMap<Dependency,Injectable> map=HashMap<Dependency, Injectable>()) {
	shared  Injectable? add(Dependency description, Injectable injectable) {
		return map.put(description,injectable);
	}
	

	
	shared  Injectable? get(Dependency description) => map.get(description);

	string=> map.fold("")((String initial, Dependency dependency -> Injectable injectable) => initial + ",``dependency.identification``" )	;
}
