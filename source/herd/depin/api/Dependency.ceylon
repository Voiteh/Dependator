import ceylon.language.meta.declaration {
	NestableDeclaration
}

shared abstract class Dependency {
	
	shared static
	interface Decorator {
		shared formal Dependency decorate(Dependency dependency);
	}
	
	shared static
	class Definition(shared NestableDeclaration declaration, shared Identification identification) {
		shared actual Boolean equals(Object that) {
			if (is Definition that) {
				return declaration.openType==that.declaration.openType&&
						identification==that.identification;
			} else {
				return false;
			}
		}
		
		shared actual Integer hash {
			variable Integer hash = 1;
			hash = 31*hash + declaration.openType.hash;
			hash = 31*hash + identification.hash;
			return hash;
		}
		
		string => "<``declaration.openType`` ``identification``>";
	}
	shared static class ResolutionError(
		String? description=null,
		Throwable? cause=null
	) 
			extends Exception(description, cause){}
	
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
	
	
	throws(`class ResolutionError`)
	shared formal Anything resolve;
	
	shared actual String string {
		if (exists container) {
			return "``container``::``definition`` ``parameters``";
		}
		return "``definition`` ``parameters``";
	}
}
