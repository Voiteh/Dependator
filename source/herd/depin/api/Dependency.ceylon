import ceylon.language.meta.declaration {
	OpenType
}

shared abstract class Dependency {
	
	shared static
	interface Decorator {
		shared formal Dependency decorate(Dependency dependency);
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
	shared {Decorator*} decorators;
	shared new (Definition definition, Dependency? container = null, {Dependency*} parameters = empty, {Decorator*} decorators = empty) {
		this.container = container;
		this.parameters = parameters;
		this.definition = definition;
		this.decorators = decorators;
	}
	shared new decorated(Dependency decorating) {
		this.container = decorating.container;
		this.parameters = decorating.parameters;
		this.definition = decorating.definition;
		this.decorators = decorating.decorators;
	}
	
	shared formal Anything resolve;
	
	shared actual String string {
		if (exists container) {
			return "``container``::``definition`` ``parameters``";
		}
		return "``definition`` ``parameters``";
	}
}
