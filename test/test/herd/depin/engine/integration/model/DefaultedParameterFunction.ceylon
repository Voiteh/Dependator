shared class DefaultedParameterFunction(shared String defaultedFunction()=> fixture.defaultedParameterFunction.param) {

	shared actual Boolean equals(Object that) {
		if (is DefaultedParameterFunction that) {
			return true;
		}
		else {
			return false;
		}
	}
	
	shared actual Integer hash {
		variable value hash = 1;
		return hash;
	}
	
	
}