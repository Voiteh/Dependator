import ceylon.language.meta.declaration {
	OpenType
}

shared abstract class Dependency {
	
	shared static
	interface Tree {
		shared formal Dependency? get(Definition definition);
		shared formal class Mutator() {
			shared formal Dependency? add(Dependency dependency);
		}
	}
	
	shared static
	class Definition(shared OpenType type, shared Identification identification) {
		shared actual Boolean equals(Object that) {
			if (is Definition that) {
				return type==that.type &&
						identification==that.identification;
			} else {
				return false;
			}
		}
		
		shared actual Integer hash {
			variable Integer hash = 1;
			hash = 31*hash + type.hash;
			hash = 31*hash + identification.hash;
			return hash;
		}
		
		string => "``type`` ``identification``";
	}
	
	shared Definition definition;
	shared {Dependency*} parameters;
	shared Dependency? container;
	shared new (Definition definition, Dependency? container = null, {Dependency*} parameters = empty) {
		this.container = container;
		this.parameters = parameters;
		this.definition = definition;
	}
	
	shared formal Anything resolve;
	
	shared actual String string {
		if (exists container) {
			return "``container``::``definition`` ``parameters``";
		}
		return "``definition`` ``parameters``";
	}
}