import ceylon.language.meta.declaration {
	NestableDeclaration
}
import herd.depin.engine.dependency {

	Identification
}



shared abstract class Dependency {
	

	
	
	shared static abstract class Decorated(Dependency dependency,Decorator decorator)  extends Dependency.decorated(dependency){
		shared Decorator[] decorators=if (is Decorated dependency) then dependency.decorators.withTrailing(decorator) else [decorator];
	}
	
	shared static
	interface Decorator {
		shared formal Decorated decorate(Dependency dependency);
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
	) extends Exception(description, cause){}
	
	shared Definition definition;
	shared {Dependency*} parameters;
	shared Dependency? container;


	shared new (Definition definition, Dependency? container = null, {Dependency*} parameters = empty) {
		this.container = container;
		this.parameters = parameters;
		this.definition = definition;

	}
	new decorated(Dependency decorating) {
		this.container = decorating.container;
		this.parameters = decorating.parameters;
		this.definition = decorating.definition;
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
