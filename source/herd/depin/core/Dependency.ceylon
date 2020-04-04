import herd.depin.core.internal.dependency {
	TypeIdentifier
}
import ceylon.language.meta.declaration {
	NestableDeclaration
}

"Defines abstraction over given declaration bound to be injected. Given [[Dependency]] has it's definition. "
shared abstract class Dependency {
	"Depdency decorated with annotation implementing this interface, will change [[Dependency.resolve]] functionality works depending on implementation."
	shared static interface Decorator {
	
		
		"Instantiates decorated dependency"
		throws (`class DecorationError`, "Whenver decoration is not possible")
		shared formal Decoration decorate(Dependency dependency);
	}
	
	shared static class DecorationError(String description, Throwable? cause) extends Exception(description, cause) {}
	
	"Used for creating of decorated dependency, reduces runtime errors with missing decorator passed as parameters."
	shared static
	abstract class Decoration(
		"Dependency to be decorated with this decoration"
		Dependency dependency,
		"Decorator which is decorating [[dependency]]"
		Decorator decorator
	) extends Dependency.decoration(dependency) {
		
		"Decorators decorating [[dependency]]"
		shared Decorator[] decorators = if (is Decoration dependency) then dependency.decorators.withTrailing(decorator) else [decorator];
	}

	"Thrown whenver [[Dependency.resolve]] failes to complete succesfully"
	shared static
	class ResolutionError(
		String? description,
		Throwable? cause
	) extends Exception(description, cause) {}
	
	
	"Identifies type providing ability to easly retreive instance of dependency."
	shared TypeIdentifier identifier;
	
	"Name of dependency"
	shared String name;
	
	"Declaration of given dependency"
	shared NestableDeclaration declaration;
	
	shared new (
		"Name of dependency"
		String name,
		"Identifies type providing ability to easly retreive instance of dependency."
		TypeIdentifier definition,
		"Declaration of given dependency"
		NestableDeclaration declaration
	) {
		this.name = name;
		this.identifier = definition;
		this.declaration = declaration;
	}
	
	"Constructor used to decorate dependency"
	new decoration(
		"Decorated dependency"
		Dependency decorated
	) {
		this.name = decorated.name;
		this.identifier = decorated.identifier;
		this.declaration = decorated.declaration;
	}
	
	"Resolve given [[Dependency]] declaration to object or null, which this depedency represents"
	throws (`class ResolutionError`, "Thrown whenver [[Dependency.resolve]] failes to complete succesfully")
	shared formal Anything resolve;
	
	shared actual default String string = "``identifier`` ``name`` ";
}
