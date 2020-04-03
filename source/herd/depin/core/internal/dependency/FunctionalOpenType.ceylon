import ceylon.language.meta.declaration {
	OpenType
}


"Types for lookup in tree"
shared class FunctionalOpenType(
	"oepn type of declaration"
	shared OpenType returnType,
	"Parameters"
	shared TypeIdentifier[] parameters) {
	 
	 

	shared actual Boolean equals(Object that) {
		if (is FunctionalOpenType that) {
			return returnType==that.returnType && 
				parameters==that.parameters;
		}
		else {
			return false;
		}
	}
	
	shared actual Integer hash {
		variable value hash = 1;
		hash = 31*hash + returnType.hash;
		hash = 31*hash + parameters.hash;
		return hash;
	}
	

		
	string = "``returnType``(``parameters``)";
	
}
