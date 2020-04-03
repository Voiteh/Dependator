import ceylon.language.meta.declaration {
	NestableDeclaration,
	CallableConstructorDeclaration,
	ClassDeclaration
}
import herd.depin.core.internal.dependency {
	TypeIdentifier
}


"Defines abstraction over given declaration bound to be injected. Given [[Dependency]] has it's definition. 
 For function depdendencies [[Dependency.parameters]] will be present. For classes and member classes [[Dependency.container]] will be present."
shared abstract class Dependency {
	
	"Used for creating of decorated dependency, reduces runtime errors with missing decorator passed as parameters."
	shared static
	abstract class Decorated(Dependency dependency, Decorator decorator) extends Dependency.decorated(dependency) {
		shared Decorator[] decorators = if (is Decorated dependency) then dependency.decorators.withTrailing(decorator) else [decorator];
	}
	"Depdency decorated with annotation implementing this interface, will change [[Dependency.resolve]] function works depending on implementation. "
	shared static
	interface Decorator {
		"Instantiates decorated dependency"
		shared formal Decorated decorate(Dependency dependency);
	}
	
	
	"Thrown whenver [[Dependency.resolve]] failes to complete succesfully"
	shared static
	class ResolutionError(
		String? description,
		Throwable? cause) extends Exception(description, cause) {}
	
	
	"Definition of this dependency"
	shared TypeIdentifier identifier;
	
	//TODO remove this from dependency provide all required data
	"Declaration of this dependency"
	shared NestableDeclaration declaration;
	
	"Parameters of this function dependency"
	shared {Dependency*} parameters;
	"Container of this nested dependecy"
	shared Dependency? container;
	
	shared new (
		NestableDeclaration declaration,
		TypeIdentifier definition,
		Dependency? container = null,
		{Dependency*} parameters = empty) {
		this.declaration = declaration;
		this.container = container;
		this.parameters = parameters;
		this.identifier = definition;
	}
	
	new decorated(Dependency decorating) {
		this.declaration = decorating.declaration;
		this.container = decorating.container;
		this.parameters = decorating.parameters;
		this.identifier = decorating.identifier;
	}
	
	"Resolve given [[Dependency]] declaration to object or null, which this depedency represents"
	throws (`class ResolutionError`)
	shared formal Anything resolve;
	
	 
	
	shared String name {
		variable String? result;
		try {
			if (exists namedAnnotation = declaration.annotations<NamedAnnotation>().first) {
				result = namedAnnotation.name;
			} else {
				switch (declaration)
				case (is ClassDeclaration) {
					assert (exists value first = declaration.name.first?.lowercased);
					value newName = String({ first,
							*declaration.name.rest });
					result = newName;
				}
				case (is CallableConstructorDeclaration) {
					assert (exists value first = declaration.container.name.first?.lowercased);
					if (declaration.name.empty) {
						value newName = String({ first,
								*declaration.container.name.rest });
						result = newName;
					} else {
						result = declaration.name;
					}
				}
				else {
					result = declaration.name;
				}
			}
		} catch (Throwable x) {
			//Ceylon BUG (https://github.com/eclipse/ceylon/issues/7448)!!!
			//We can't identifiy parameter by annotations but for now we can use name of the parameter.
			//This will be enough for most of cases. 
			result = declaration.name;
		}
		assert (exists shadow = result);
		return shadow;
	}
	
	shared actual String string = if(exists container) then "``container``$``identifier`` ``name`` " else "``identifier`` ``name`` ";
}
