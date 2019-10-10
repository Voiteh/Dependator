"Abstraction over ceylon model providing ablity to define what and how to inject."
shared abstract class Injection {
	
	"Thrown whenever [[Depin.inject]] has failed "
	shared static
	class Error(Throwable cause, shared Injectable<Anything> injectable, shared Anything container = null, shared {Anything*} parameters = empty)
			extends Exception(
				"Injection failed for ``injectable`` `` if (exists container) then ", with container:``container`` " else ""`` `` if (!parameters.empty) then ", parameters: ``parameters``" else "" ``"
				, cause
			) {}
	
	Injectable<Anything> injectable;
	Dependency? container;
	{Dependency*} parameters;
	shared new (Injectable<Anything> injectable, Dependency? container, {Dependency*} parameters = empty) {
		this.parameters = parameters;
		this.container = container;
		this.injectable = injectable;
	}
	"Injects given parameters and container into injectable"
	throws (`class Error`)
	shared formal Anything inject;
	
	shared actual String string {
		if (exists container) {
			return "``container``::``injectable`` ``parameters``";
		}
		return "``injectable`` ``parameters``";
	}
}
