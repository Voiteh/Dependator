import herd.depin.api {
	Dependency,
	Injectable,
	Register
}
import ceylon.collection {
	HashMap,
	LinkedList,
	MutableMap
}
import ceylon.language.meta.model {
	Type
}

shared class DefaultRegister(MutableMap<Dependency,Injectable> map=HashMap<Dependency, Injectable>())  satisfies Register{
	shared actual Injectable? add(Dependency description, Injectable injectable) {
		return map.put(description,injectable);
	}
	

	
	shared actual Injectable? get(Dependency description) => map.get(description);
	
}
shared class Controls() extends LinkedList<Type<Annotation>>(){}