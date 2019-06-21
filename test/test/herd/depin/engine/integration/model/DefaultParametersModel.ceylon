shared class DefaultParametersModel(shared String nonDefault,shared String defaultedParameter=fixture.defaultParameter.text) {
	

	shared actual Boolean equals(Object that) {
		if (is DefaultParametersModel that) {
			return nonDefault==that.nonDefault && 
				defaultedParameter==that.defaultedParameter;
		}
		else {
			return false;
		}
	}
	
	shared actual Integer hash {
		variable value hash = 1;
		hash = 31*hash + nonDefault.hash;
		hash = 31*hash + defaultedParameter.hash;
		return hash;
	}
	
}