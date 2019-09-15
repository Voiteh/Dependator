import ceylon.language.meta.declaration {
	NestableDeclaration
}


"Defines abstraction over given declaration bound to be injected. Given [[Dependency]] has it's definition created from [[NestableDeclaration]] and [[Identification]]. 
 For function depdendencies [[Dependency.parameters]] will be present. For classes and member classes [[Dependency.container]] will be present."
shared abstract class Dependency {
	
	"Used for creating of decorated dependency, reduces runtime errors with missing decorator passed as parameters."
	shared static abstract class Decorated(Dependency dependency,Decorator decorator)  extends Dependency.decorated(dependency){
		shared Decorator[] decorators=if (is Decorated dependency) then dependency.decorators.withTrailing(decorator) else [decorator];
	}
	"Depdency decorated with annotation implementing this interface, will change [[Dependency.resolve]] function works depending on implementation. "
	shared static
	interface Decorator {
		"Instantiates decorated dependency"
		shared formal Decorated decorate(Dependency dependency);
	}
	
	"Defines information about dependency"
	shared static
	class Definition(
		"Declaration of dependency"
		shared NestableDeclaration declaration,
		"Identification of dependnecy"
		 shared Identification identification
	) {
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
	"Thrown whenver [[Dependency.resolve]] failes to complete succesfully"
	shared static class ResolutionError(
		String? description=null,
		Throwable? cause=null
	) extends Exception(description, cause){}
	
	"Definition of given dependency"
	shared Definition definition;
	"Parameters of given function dependency"
	shared {Dependency*} parameters;
	"Container of given nested dependecy"
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
	
	"Resolve given [[Dependency]] declaration to object or null, which this depedency represents"
	throws(`class ResolutionError`)
	shared formal Anything resolve;
	
	shared actual String string {
		if (exists container) {
			return "``container``::``definition`` ``parameters``";
		}
		return "``definition`` ``parameters``";
	}
}
