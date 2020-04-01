import ceylon.language.meta.declaration {
	OpenType,
	NestableDeclaration
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
	
	"Defines information about dependency"
	shared static
	class Definition(
		"Type of depdendency"
		shared OpenType type,
		"Name of dependency may be null for anonymous functions"
		shared String name,
		"Only for functional declarations"
		shared Definition[] nested = []) {
		
		shared actual Integer hash {
			variable value hash = 1;
			hash = 31*hash + type.hash;
			hash = 31*hash + name.hash;
			hash = 31*hash + nested.hash;
			return hash;
		}
		
		shared actual Boolean equals(Object that) {
			if (is Definition that) {
				return type==that.type &&
						name==that.name &&
						nested==that.nested;
			}
			return false;
		}
		shared OpenType[] types {
			return nested.map((Definition def) => def.type).sequence().withLeading(type);
		}
		
		shared actual String string = if (nested.empty) then "``type`` ``name`` " else "``type`` ``name`` ``nested`` ";
	}
	"Thrown whenver [[Dependency.resolve]] failes to complete succesfully"
	shared static
	class ResolutionError(
		String? description,
		Throwable? cause) extends Exception(description, cause) {}
	
	
	"Definition of this dependency"
	shared Definition definition;
	
	"Declaration of this dependency"
	shared NestableDeclaration declaration;
	
	"Parameters of this function dependency"
	shared {Dependency*} parameters;
	"Container of this nested dependecy"
	shared Dependency? container;
	
	
	shared new (
		NestableDeclaration declaration,
		Definition definition,
		Dependency? container = null,
		{Dependency*} parameters = empty
	) {	
		this.declaration = declaration;
		this.container = container;
		this.parameters = parameters;
		this.definition = definition;
	}
	
	new decorated(Dependency decorating) {
		this.declaration = decorating.declaration;
		this.container = decorating.container;
		this.parameters = decorating.parameters;
		this.definition = decorating.definition;
	}
	
	"Resolve given [[Dependency]] declaration to object or null, which this depedency represents"
	throws (`class ResolutionError`)
	shared formal Anything resolve;
	
	shared actual String string {
		
		value builder = StringBuilder();
		if (exists container) {
			builder.append("``container``::");
		}
		builder.append("``definition``");
		
		if (!parameters.empty) {
			String params = parameters.fold("")((String partial, Dependency next) => if (partial.empty) then "``next``" else "``partial``, ``next``");
			builder.append(" [``params``]");
		}
		return builder.string;
	}
}
