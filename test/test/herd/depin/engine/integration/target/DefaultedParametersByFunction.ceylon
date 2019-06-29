import herd.depin.api {
	target
}
shared class DefaultedParametersByFunction(shared String defaultedByFunction) {
	

	shared actual Boolean equals(Object that) {
		if (is DefaultedParametersByFunction that) {
			return defaultedByFunction==that.defaultedByFunction;
		}
		else {
			return false;
		}
	}
	
	shared actual Integer hash => defaultedByFunction.hash;
	
}